module Admin
  # PeopleController
  class PeopleController < AdminController
    before_action :set_person, only: %i[show edit update destroy]
    before_action :show_history, only: %i[index]
    before_action :set_attachments
    before_action :authorization, except: %i[reload]

    # GET /people
    def index
      @q = Person.ransack(params[:q])
      people = @q.result(distinct: true)
      @objects = people.page(@current_page).order(position: :asc)
      @total = people.size
      @people = Person.all
      if !@objects.first_page? && @objects.size.zero?
        redirect_to people_path(page: @current_page.to_i.pred, search: @query)
      end
      format
    end

    # GET /people/1
    def show; end

    # GET /people/new
    def new
      @person = Person.new
    end

    # GET /people/1/edit
    def edit; end

    # POST /people
    def create
      @person = Person.new(person_params)

      if @person.save
        redirect(@person, params)
      else
        render :new
      end
    end

    # PATCH/PUT /people/1
    def update
      if @person.update(person_params)
        redirect(@person, params)
      else
        render :edit
      end
    end

    def clone
      @person = Person.clone_record params[:person_id]

      if @person.save
        redirect_to admin_people_path
      else
        render :new
      end
    end

    # DELETE /people/1
    def destroy
      @person.destroy
      redirect_to admin_people_path, notice: actions_messages(@person)
    end

    def destroy_multiple
      Person.destroy redefine_ids(params[:multiple_ids])
      redirect_to(
        admin_people_path(page: @current_page, search: @query),
        notice: actions_messages(Person.new)
      )
    end

    def upload
      Person.upload(params[:file])
      redirect_to(
        admin_people_path(page: @current_page, search: @query),
        notice: actions_messages(Person.new)
      )
    end

    def reload
      @q = Person.ransack(params[:q])
      people = @q.result(distinct: true)
      @objects = people.page(@current_page).order(position: :desc)
    end

    def sort
      Person.sorter(params[:row])
      @q = Person.ransack(params[:q])
      people = @q.result(distinct: true)
      @objects = people.page(@current_page)
    end

    private

    def format
      respond_to do |format|
        format.html
        format.csv { send_data @people.to_csv }
        format.xls # { send_data @people.to_xls }
        format.json { render json: @people }
      end
    end

    def authorization
      authorize Person
    end

    def set_attachments
      @attachments = %w[
        logo brand photo avatar cover image picture banner attachment pic file
      ]
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_person
      @person = Person.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def person_params
      params.require(:person).permit(:name, :bio, :photo, :email, :phone, :age, :weight, :birth, :hour, :user_id, :public, :arrived, :decimal, :position, :deleted_at)
    end

    def show_history
      get_history(Person)
    end
  end
end
