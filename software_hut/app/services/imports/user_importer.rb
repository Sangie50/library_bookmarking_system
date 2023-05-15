# A class for importing users in a file from a CSV
# Authors: Caroline Osbourne, Connor Mitchell

require 'csv'
class Imports::UserImporter

  # A method for initi
  def initialize(file)
    @path = file.path
  end

  # A function for importing users when a CSV is passed in from initalising the file
  def import_users
    csv = CSV.read(@path, headers: true, skip_blanks: true)
    csv_valid = (['username', 'email', 'role', 'department'] - csv.headers.compact).empty?
    return false unless csv_valid
    csv.each do |user|
      new_user = User.new
      new_user.username = user["username"]
      new_user.email = user["email"]
      new_user.save!
      case user["role"]
      when "dlo"
        new_user.make_dlo(user["department"])
      when "ddss"
        new_user.make_ddss
      when "academic"
        new_user.make_academic(user["department"])
      when "admin"
        new_user.make_admin
      end          
    end
    return true
  end
end
 