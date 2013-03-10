class Msg < ActiveRecord::Base
  scope :in_room,    ->(room)    { where 'room = ?', room }
  scope :newer_than, ->(last_id) { where 'id > ?', last_id }

  def self.fetch_next(room, last_id)
    self.all.in_room(room).newer_than(last_id).order("id").limit(10).to_a
  end
end
