class UsersStorage
  def collection
    @collection ||= {}
  end

  def emails_index
    @emails_index ||= []
  end
end
