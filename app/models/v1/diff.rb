# Diff model is used by the application
class V1::Diff < ApplicationRecord

  # Comparing left and right contents and returning the result of it
  def jsons_comparison
    return "Left or Right aren't provided yet"   if left.nil? || right.nil?
    return "Left and Right are equaled"          if left.eql? right
    return "Left and Right have different sizes" if left.size != right.size

    index = offset = length = 0
    diffs = Array.new

    left.chars.zip(right.chars).each do |left_char, right_char|
      if left_char == right_char && length > 0
        diffs.push({offset: offset, length: length})
        length = 0
      end

      if left_char != right_char
        offset = index if length == 0
        length += 1
      end
      index += 1
    end

    if length > 0
      diffs.push({offset: offset, length: length})
    end

    diffs
  end
end
