module Globals
  module App
    TITLE = 'Chatroom'
  end

  module Tooltip
    AGE_LIMIT = "Users must be at least #{User::MIN_USER_AGE} years of age."
    PW_REQS = "Password must be #{User::MIN_PW_LEN}-#{User::MAX_PW_LEN} characters " +
              "and contain at least 1 letter, 1 number, and 1 special character."
  end
end
