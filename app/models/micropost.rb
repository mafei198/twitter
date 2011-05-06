# == Schema Information
# Schema version: 20110408165221
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  validates :content, :presence => true, :length => { :maximum => 140}
  validates :user_id, :presence => true

  default_scope :order => 'microposts.created_at DESC'

  # Return microposts from the users being followed by the given user.
  scope :from_users_followed_by, lambda {|user| followed_by(user)}

  private

    # Return an SQL condition for users followed by the giben user.
    # We include the user's own id as well.
    def self.followed_by(user)
      #followed_ids = user.following.map(&:id).join(",")
      # why don't use the above? fore this subselect arranges for all the set logic to be pushed into the database, which is more efficient.
      followed_ids = %(SELECT followed_id FROM relationships
                      WHERE follower_id = :user_id)
      where("user_id IN (#{followed_ids}) OR user_id = :user_id",
            {:user_id => user})
    end

  #def self.form_users_followed_by(user)
    #followed_ids = user.following.map(&:id).join(",")
    #where("user_id IN (#{followed_ids}) OR user_id = ?", user)
  #end

end
