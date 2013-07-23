class Hash
  def stringify_values
    dup.stringify_values!
  end

  def stringify_values!
    inject(self.class.new) do |new_hash, (key, value)|
      new_hash[key] = value.kind_of?(String) ? value : value.to_s
      new_hash
    end
  end
end
