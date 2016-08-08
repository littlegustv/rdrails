class SkillsController < ApplicationController
	def index
		@skills = Skill.all
		respond_to do |format|
			format.html
			format.json {render json: @skills.map { |skill| {skill_id: skill.id, name: skill.name, cp: skill.cp, level: skill.cp } } }
		end
	end

	def show
		@skill = Skill.find(params[:id])
	end

	def new
		@skill = Skill.new
	end

	def edit
		@skill = Skill.find(params[:id])
		render :new
	end

	def create
		@skill = Skill.create(skills_params)
		redirect_to skills_path
	end

	def update
		@skill = Skill.find(params[:id])
		@skill.update(skills_params)
		redirect_to skills_path
	end

	private

	def skills_params
		params.require(:skill).permit(:id, :name, :cp, :level)
	end
end