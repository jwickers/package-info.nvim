local spy = require("luassert.spy")

local core = require("package-info.core")

local reset = require("package-info.tests.utils.reset")
local file = require("package-info.tests.utils.file")

describe("Core reload_buffer", function()
    before_each(function()
        reset.core()
        reset.state()
    end)

    it("should reload the buffer if it's package.json", function()
        file.create_package_json({ go = true })

        core.load_plugin()

        spy.on(vim, "cmd")
        spy.on(vim.fn, "winsaveview")
        spy.on(vim.fn, "winrestview")

        core.__reload_buffer()

        file.delete_package_json()

        assert.spy(vim.cmd).was_called(1)
        assert.spy(vim.cmd).was_called_with("edit")
        assert.spy(vim.fn.winsaveview).was_called(1)
        assert.spy(vim.fn.winrestview).was_called(1)
    end)

    it("shouldn't reload the buffer if it's not in package.json", function()
        spy.on(vim, "cmd")
        spy.on(vim.fn, "winsaveview")
        spy.on(vim.fn, "winrestview")

        core.__reload_buffer()

        assert.spy(vim.cmd).was_called(0)
        assert.spy(vim.fn.winsaveview).was_called(0)
        assert.spy(vim.fn.winrestview).was_called(0)
    end)
end)
