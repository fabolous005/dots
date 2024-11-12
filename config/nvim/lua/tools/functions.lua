function string.starts_with(String, Start)
  return string.sub(String, 1, string.len(Start)) == Start
end

function string.containsSpaces(String)
  return string.match(String, "%s") ~= nil
end

function table.insert_unique(my_table, str)
  for _, value in ipairs(table) do
    if value and value == str then
      return
    end
  end
  table.insert(my_table, str)
end
