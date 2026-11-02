const lest = require("@lest")
const describe, it, expect = lest.describe, lest.it, lest.expect

const scope = require("./scope")

describe("scope", function()
	describe("clock", function()
		it("starts at frame 0 with no time", function()
			const s = scope.new()
			expect(s:frame()).toBe(0)
			expect(s:dt()).toBe(0)
			expect(s:time()).toBe(0)
		end)

		it("advances the frame, dt and time with next", function()
			const s = scope.new()
			s:next(0.25)
			s:next(0.5)
			expect(s:frame()).toBe(2)
			expect(s:dt()).toBe(0.5)
			expect(s:time()).toBe(0.75)
		end)

		it("shares the clock with keyed scopes", function()
			const s = scope.new()
			const child = s:key("child")
			s:next(0.5)
			expect(child:frame()).toBe(1)
			expect(child:dt()).toBe(0.5)
		end)
	end)

	describe("key", function()
		it("returns the same scope for the same name in one frame", function()
			const s = scope.new()
			expect(s:key("a")).toBe(s:key("a"))
		end)

		it("returns different scopes for different names", function()
			const s = scope.new()
			expect(s:key("a") ~= s:key("b")).toBe(true)
		end)

		it("keeps a scope that is requested every frame", function()
			const s = scope.new()
			const first = s:key("a")
			s:next(1 / 60)
			expect(s:key("a")).toBe(first)
			s:next(1 / 60)
			expect(s:key("a")).toBe(first)
		end)

		it("purges a scope that isn't requested for a frame", function()
			const s = scope.new()
			const first = s:key("a")
			s:next(1 / 60)
			s:key("other")
			s:next(1 / 60)
			expect(s:key("a") ~= first).toBe(true)
		end)

		it("keeps children of a scope that was visited but didn't key them", function()
			const s = scope.new()
			const inner = s:key("a"):key("b")
			s:next(1 / 60)
			s:key("a") -- e.g. an expensive() cache hit skipped the inner key
			s:next(1 / 60)
			expect(s:key("a"):key("b")).toBe(inner)
		end)

		it("sets the parent of keyed scopes", function()
			const s = scope.new()
			expect(s:key("a").parent).toBe(s)
		end)
	end)

	describe("once", function()
		it("runs the initialiser only once", function()
			const s = scope.new()
			local calls = 0
			const function init()
				calls += 1
				return {}
			end
			const a = s:once(init)
			const b = s:once(init)
			expect(calls).toBe(1)
			expect(a).toBe(b)
		end)

		it("runs again after the scope is purged", function()
			const s = scope.new()
			local calls = 0
			const function init()
				calls += 1
				return {}
			end
			s:key("a"):once(init)
			s:next(1 / 60)
			s:key("other")
			s:next(1 / 60)
			s:key("a"):once(init)
			expect(calls).toBe(2)
		end)
	end)

	describe("get and set", function()
		it("returns the default before anything is set", function()
			expect(scope.new():get(42)).toBe(42)
		end)

		it("doesn't apply a set value until the next frame", function()
			const s = scope.new()
			s:set(5)
			expect(s:get(0)).toBe(0)
			s:next(1 / 60)
			expect(s:get(0)).toBe(5)
		end)

		it("applies the last value set in a frame", function()
			const s = scope.new()
			s:set(1)
			s:set(2)
			s:next(1 / 60)
			expect(s:get(0)).toBe(2)
		end)

		it("keeps the value in later frames", function()
			const s = scope.new()
			s:set(5)
			s:next(1 / 60)
			s:next(1 / 60)
			expect(s:get(0)).toBe(5)
		end)
	end)

	describe("cleanup", function()
		const function skip_frame(s: scope.Scope)
			s:next(1 / 60)
			s:key("other")
		end

		const function purge_unrequested(s: scope.Scope)
			skip_frame(s)
			skip_frame(s)
			s:next(1 / 60)
		end

		it("returns what was registered", function()
			const s = scope.new()
			const fn = function() end
			expect(s:on_cleanup(fn)).toBe(fn)
		end)

		it("runs when a key stops being requested", function()
			const s = scope.new()
			local calls = 0
			s:key("a"):on_cleanup(function()
				calls += 1
			end)
			purge_unrequested(s)
			expect(calls).toBe(1)
		end)

		it("doesn't run while the frame that purged it is still being built", function()
			const s = scope.new()
			local calls = 0
			s:key("a"):on_cleanup(function()
				calls += 1
			end)
			skip_frame(s)
			skip_frame(s) -- the root flips here and purges "a"
			expect(calls).toBe(0)
			s:next(1 / 60) -- cleanups run between frames
			expect(calls).toBe(1)
		end)

		it("runs only once", function()
			const s = scope.new()
			local calls = 0
			s:key("a"):on_cleanup(function()
				calls += 1
			end)
			purge_unrequested(s)
			purge_unrequested(s)
			expect(calls).toBe(1)
		end)

		it("never runs for a key that's requested every frame", function()
			const s = scope.new()
			local calls = 0
			s:key("a"):on_cleanup(function()
				calls += 1
			end)
			for _ = 1, 5 do
				s:next(1 / 60)
				s:key("a")
			end
			expect(calls).toBe(0)
		end)

		it("runs a scope's cleanups in reverse registration order", function()
			const s = scope.new()
			const order = {}
			const a = s:key("a")
			a:on_cleanup(function()
				table.insert(order, "first")
			end)
			a:on_cleanup(function()
				table.insert(order, "second")
			end)
			purge_unrequested(s)
			expect(order[1]).toBe("second")
			expect(order[2]).toBe("first")
		end)

		it("cleans up nested scopes innermost first", function()
			const s = scope.new()
			const order = {}
			const outer = s:key("outer")
			outer:on_cleanup(function()
				table.insert(order, "outer")
			end)
			outer:key("inner"):on_cleanup(function()
				table.insert(order, "inner")
			end)
			purge_unrequested(s)
			expect(order[1]).toBe("inner")
			expect(order[2]).toBe("outer")
		end)

		it("keeps cleanups of children under a scope that was visited but didn't key them", function()
			const s = scope.new()
			local calls = 0
			s:key("a"):key("b"):on_cleanup(function()
				calls += 1
			end)
			for _ = 1, 3 do
				s:next(1 / 60)
				s:key("a") -- e.g. an expensive() cache hit skipped the inner key
			end
			expect(calls).toBe(0)
		end)

		it("destroys tables with a destroy method", function()
			const s = scope.new()
			local destroyed = false
			s:key("a"):on_cleanup({
				destroy = function()
					destroyed = true
				end,
			})
			purge_unrequested(s)
			expect(destroyed).toBe(true)
		end)

		it("keeps running other cleanups when one errors", function()
			const s = scope.new()
			local ran = false
			const a = s:key("a")
			a:on_cleanup(function()
				ran = true
			end)
			a:on_cleanup(function()
				error("cleanup failed") -- registered last, so it runs first
			end)
			purge_unrequested(s)
			expect(ran).toBe(true)
		end)

		it("forgets the scope's value once purged", function()
			const s = scope.new()
			const a = s:key("a")
			a:set(5)
			purge_unrequested(s)
			expect(s:key("a"):get(0)).toBe(0)
		end)

		it("errors when a purged scope is used again", function()
			const s = scope.new()
			const stale = s:key("a")
			purge_unrequested(s)
			expect((pcall(stale.key, stale, "child"))).toBe(false)
			expect((pcall(stale.on_cleanup, stale, function() end))).toBe(false)
		end)

		describe("destroy", function()
			it("runs every cleanup immediately", function()
				const s = scope.new()
				local calls = 0
				const function count()
					calls += 1
				end
				s:on_cleanup(count)
				s:key("a"):on_cleanup(count)
				s:key("a"):key("b"):on_cleanup(count)
				s:destroy()
				expect(calls).toBe(3)
			end)

			it("doesn't run cleanups again on later frames", function()
				const s = scope.new()
				local calls = 0
				s:key("a"):on_cleanup(function()
					calls += 1
				end)
				s:destroy()
				s:next(1 / 60)
				expect(calls).toBe(1)
			end)
		end)
	end)
end)

return nil
