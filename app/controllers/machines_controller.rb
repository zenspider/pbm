class MachinesController < InheritedResources::Base
  respond_to :xml, :json, only: %i[index show]
  has_scope :by_name

  def create
    @machine = Machine.new(machine_params)
    if @machine.save
      redirect_to @machine, notice: 'Machine was successfully created.'
    else
      render action: 'new'
    end
  end

  def autocomplete
    if params[:region_level_search].nil?
      render json: Machine.where("clean_items(name) ilike '%' || clean_items(?) || '%'", params[:term]).sort_by(&:name).map { |m| { label: m.name_and_year, value: m.name_and_year, id: m.id, group_id: m.machine_group_id } }
    else
      render json: @region.machines.select { |m| m.name_and_year =~ /#{Regexp.escape params[:term] || ''}/i }.sort_by(&:name).map { |m| { label: m.name_and_year, value: m.name_and_year, id: m.id, group_id: m.machine_group_id } }
    end
  end

  def index
    respond_with(@machines = apply_scopes(Machine).all)
  end

  private

  def machine_params
    params.require(:machine).permit(:name, :ipdb_link, :year, :manufacturer, :machine_group_id, :ic_eligible)
  end
end
