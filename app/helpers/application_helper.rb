module ApplicationHelper
  def voting_button(direction, votable)
    model_name = votable.class.model_name.singular
    path = self.send("#{model_name}_#{direction}vote_path", votable)
    text = case direction
    when :up
      "^"
    when :down
      "v"
    end
    button_to text, path, {:remote => true, :form_class => 'voting', :class => "button", :form => {'data-type' => 'json'}}
  end
end
