class TasksController < ApplicationController
  # GET /tasks
  # GET /tasks.xml
  def index

    params[:fini] = Date.new(2011,1,1)
    params[:ffin] = params[:fini].next_year-1

    if (params[:tdato] == nil)
      params[:tdato] = 'Tareas Avance'
    end
    if (params[:id] == nil)
      params[:id] = 1
    end

    @tasks = gettasksbymonth(Account.find(1), Account.find(params[:id].to_i),Array.new,'>',params[:fini],params[:ffin],params[:tdato])
    @tdato = params[:tdato]
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tasks }
    end
  end

  #devuelve las tareas agrupadas en la jerarquía de cuentas y meses
  def gettasksbymonth(account, accountorig, arrtasks,tabspc,fini,ffin,tdato)
    tabspc = tabspc + '---'

    account.children.each {|a|
      a.name = tabspc + a.name
      
      case tdato
        when 'Tareas Planeadas'
          if (a.has_children?)
            if (a.children[0].has_children?)
              arrtasks << Task.new.tempty(a)
            else
              arrtasks << Task.new.tplanbymonth(a,fini,ffin)
            end
          else
            arrtasks << Task.new.tplanbymonth(a,fini,ffin)
          end
        when 'Tareas Real'
          if (a.has_children?)
            if (a.children[0].has_children?)
              arrtasks << Task.new.tempty(a)
            else
              arrtasks << Task.new.trealbymonth(a,fini,ffin)
            end
          else
            arrtasks << Task.new.trealbymonth(a,fini,ffin)
          end
        when 'Dias-Movil Planeados'
          arrtasks << Task.new.hsplanbymonth(a,fini,ffin,60*8)
        when 'Dias-Movil Reales'
          arrtasks << Task.new.hsrealbymonth(a,fini,ffin,60*8)
        when 'Tareas Avance'
          if (a.has_children?)
            if (a.children[0].has_children?)
              arrtasks << Task.new.tempty(a)
            else
              arrtasks << Task.new.tadvancebymonth(a,fini,ffin)
            end
          else
            arrtasks << Task.new.tadvancebymonth(a,fini,ffin)
          end
      end

      #acá va la parte recursiva
      arrtmp = Array.new
      arrtmp << a.id
      if ((accountorig.ancestor_ids << accountorig.id) & arrtmp  ).length > 0
        gettasksbymonth(a,accountorig,arrtasks,tabspc,fini,ffin,tdato)
      end
    }

    return arrtasks
  end
  
  # GET /tasks/1
  # GET /tasks/1.xml
  def show
    @task = Task.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/new
  # GET /tasks/new.xml
  def new
    @task = Task.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @task }
    end
  end

  # GET /tasks/1/edit
  def edit
    @task = Task.find(params[:id])
  end

  # POST /tasks
  # POST /tasks.xml
  def create
    @task = Task.new(params[:task])

    respond_to do |format|
      if @task.save
        format.html { redirect_to(@task, :notice => 'Task was successfully created.') }
        format.xml  { render :xml => @task, :status => :created, :location => @task }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tasks/1
  # PUT /tasks/1.xml
  def update
    @task = Task.find(params[:id])

    respond_to do |format|
      if @task.update_attributes(params[:task])
        format.html { redirect_to(@task, :notice => 'Task was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @task.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.xml
  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to(tasks_url) }
      format.xml  { head :ok }
    end
  end
end
