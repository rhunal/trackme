class CitiesGrid < BaseGrid

  scope do
    City
  end

  filter(:name, :string)
  filter(:created_at, :date, :range => true)

  column(:name, header: 'City')
  column(:country_name, header: 'Country')
  date_column(:created_at)

  column(:actions, :html => true) do |record|
    content_tag :div, class: 'btn-group' do
      concat link_to(
        '<i class="fas fa-pencil-alt"></i>'.html_safe,
        edit_polymorphic_url(record),
        class: 'btn btn-primary btn-sm'
      )

      concat link_to(
        '<i class="fas fa-trash"></i>'.html_safe,
        record,
        method: :delete,
        class: 'btn btn-danger btn-sm',
        data: {
          confirm: "Are you sure? you want to delete #{controller_name.singularize}: #{record.name}"
        }
      )
    end
  end
end
