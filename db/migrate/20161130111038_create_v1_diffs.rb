class CreateV1Diffs < ActiveRecord::Migration[5.0]
  def change
    create_table :v1_diffs do |t|
      t.string :left
      t.string :right

      t.timestamps
    end
  end
end
