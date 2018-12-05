module ItemsHelper
  def items_sorted_by(order, category_id)
    #order並び順、category_idカテゴリーで絞込み
    order ||= session[:sort_order]
    category_id ||= session[:sort_category_id]
    #並び順（指定が無ければID順）
    if Item.column_names.include?(order)
      @items = Item.order(order)
    else
      @items = Item.order(:id)
    end
    #カテゴリーの絞込み
    if category_id.to_i > 0
      @items = @items.where(category_id: category_id)
    end
    #セッションにソートの情報を保存
    session[:sort_order] = order
    session[:sort_category_id] = category_id
    return @items
  end
end
