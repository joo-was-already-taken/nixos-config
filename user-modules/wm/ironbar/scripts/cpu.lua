local function load_cpu_stat()
  local stat_file = io.open("/proc/stat")
  if stat_file == nil then
    io.stderr:write("Error: Could not read '/proc/stat' file\n")
    os.exit(1)
  end

  local stat = string.gmatch(stat_file:read(), "([^ ]+)")
  stat_file:close()

  local field_names = {
    "user", "nice", "system", "idle", "iowait",
    "irq", "softirq", "steal", "guest", "guest_nice",
  }
  local cpu = {}
  local i = 0
  for time in stat do
    if i ~= 0 then
      cpu[field_names[i]] = tonumber(time)
    end
    i = i + 1
  end

  return cpu
end

local function calculate_cpu_usage(prev, cur)
  local prev_idle = prev.idle + prev.iowait
  local cur_idle = cur.idle + prev.iowait
  local prev_non_idle = prev.user + prev.nice + prev.system + prev.irq + prev.softirq + prev.steal
  local cur_non_idle = cur.user + cur.nice + cur.system + cur.irq + cur.softirq + cur.steal

  local prev_total = prev_idle + prev_non_idle
  local cur_total = cur_idle + cur_non_idle

  local total_diff = cur_total - prev_total
  local idle_diff = cur_idle - prev_idle

  return (total_diff - idle_diff) / total_diff
end

local stat1 = load_cpu_stat()
os.execute("sleep 0.5")
local stat2 = load_cpu_stat()

local cpu_usage = calculate_cpu_usage(stat1, stat2)

print(string.format("%.1f%%", cpu_usage * 100))
