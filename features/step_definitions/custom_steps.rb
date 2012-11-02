Given /^the following movies exist:$/ do |table|
  # table is a | Star Wars    | PG     | George Lucas |   1977-05-25 |pending
  table.hashes.each do |movie|
    Movie.create(movie)
  end
end
Then /^the director of "([^"]*)" should be "([^"]*)"$/ do |arg1, arg2|
  m = Movie.find_by_title(arg1)
  m.director == arg2
end