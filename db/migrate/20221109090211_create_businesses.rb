class CreateBusinesses < ActiveRecord::Migration[7.0]
  def change
    create_table :businesses do |t|
      t.string :organisation
      t.text :address
      t.string :location
      t.string :state
      t.string :postcode
      t.string :region
      t.string :phone
      t.string :tollfree
      t.string :mobile
      t.string :fax
      t.string :email
      t.string :website
      t.string :abn
      t.string :numofemp
      t.string :bus_description1

      t.timestamps
    end
  end
end
