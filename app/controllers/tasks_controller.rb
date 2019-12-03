class TasksController < ApplicationController
  #before_action を使用し、set_taskメソッドを
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  
  #TasksController の全アクションはログインが必須
  before_action :require_user_logged_in, except: [:show]
  
  
  def index
    @tasks = current_user.tasks.order(id: :desc)
  end
    
  def show
    if logged_in? and current_user.id == @task.user_id
    else
      redirect_to root_url
    end
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.new(task_params)
    
    if @task.save
      flash[:success] = 'タスクが正常に登録されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクが登録されませんでした'
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'タスクは正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'タスクは更新されませんでした'
      render :edit
    end
  end

  def destroy
    @task.destroy
    
    flash[:success] = 'タスクは正常に削除されました' 
    redirect_to tasks_url
  end

private

  # 共通化可能な箇所をまとめる
  def set_task
    @task = Task.find_by(params[:id])
  end 

  # Strong Parameter
  def task_params
    params.require(:task).permit(:content, :status)
  end

end
