# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
directories %w(lib web config test priv) \
 .select{|d| Dir.exists?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

guard :shell do
  watch(/lib\/(.*).ex/) do |m|
    target = "test/#{m[1]}_test.exs"
    system("echo run [mix test #{target}]")
    system("mix test #{target}")
  end

  watch(/test\/(.*).exs/) do |m|
    system("echo run [mix test #{m[0]}]")
    system("mix test #{m[0]}")
  end
end

