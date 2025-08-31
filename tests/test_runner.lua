local utils_tests = require("tests.utils_tests.utils_tests")
local stream_tests = require("tests.stream_tests.stream_tests")

local files = {
    utils_tests,
    stream_tests,
}

local function print_results(results)
    print("Success: " .. results.success_count .. " Failures: " .. results.failure_count)
end

local function run_all_tests()
    local results = {
        success_count = 0,
        failure_count = 0,
    }

    for _, file in pairs(files) do
        for testcase_name, testcase in pairs(file) do
            local success, error = pcall(testcase)
            if not success then
                print(testcase_name .. ": " .. error)
                results.failure_count = results.failure_count + 1
            else
                results.success_count = results.success_count + 1
            end
        end
    end

    print_results(results)
    return results.failure_count == 0
end

local success = run_all_tests()
os.exit(success and 0 or 22)
