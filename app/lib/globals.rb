module Globals
  module App
    TITLE = 'Chatroom'
  end

  module Tooltip
    AGE_LIMIT = "Users must be at least #{User::MIN_USER_AGE} years of age."
    UNAME_REQS = "Username must be #{User::MIN_UNAME_LEN}-#{User::MAX_UNAME_LEN} characters " +
                 "and must start and end with a letter or number. " +
                 "Dashes and underscores are also allowed if NOT used consecutively."
    PW_REQS = "Password must be #{User::MIN_PW_LEN}-#{User::MAX_PW_LEN} characters " +
              "and contain at least 1 letter, 1 number, and 1 special character."
  end
end
