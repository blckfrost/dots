hl.layout.register("rectangle", {
	recalculate = function(ctx)
		local n = #ctx.targets
		if n == 0 then
			return
		end

		if n == 1 then
			ctx.targets[1]:place(ctx.area)
			return
		end

		local master = ctx.targets[1]
		local slaveArea = ctx:column(2, 2)

		-- Master always gets the left half
		master:place(ctx:column(1, 2))

		for i = 2, n do
			ctx.targets[i]:place(slaveArea)
		end
	end,
})
