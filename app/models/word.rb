class Word < ActiveRecord::Base
  validates :name, presence: true
  validates :user, presence: true
  validates :name, uniqueness: {scope: :user, message: "ワードが同じ登録者で重複しています"}

  def self.upload(file,user)
    x = Roo::Excelx.new(file.path.to_s)

    x.each_row_streaming do |row|
      name,desc = *row
      Word.create(name:name, desc:desc, user:user, removed:false)
    end
  end

end
