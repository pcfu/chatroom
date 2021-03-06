module Globals
  class App
    TITLE = 'Chatroom'
    MIN_USER_AGE = 13
    MAX_USER_AGE = 150
    MAX_DOB = Date.current.advance(years: -MIN_USER_AGE)
    MIN_DOB = Date.current.advance(years: -MAX_USER_AGE)
  end

  class Tooltip
    AGE_LIMIT = "Users must be at least #{App::MIN_USER_AGE} years of age."
  end
end
