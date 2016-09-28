class CreateWords < ActiveRecord::Migration[5.0]
  
  def self.up
    create_table :words do |t|
      t.column :eng, :string
      t.column :pl, :string
    end

    Word.new(:eng=>'yes', :pl=>'tak').save
    Word.new(:eng=>'no', :pl=>'nie').save
    Word.new(:eng=>'everything', :pl=>'wszystko').save
  end

  def self.down
    drop_table :words
  end

end
