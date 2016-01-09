import Ecto.Model
import Ecto.Query, only: [from: 2]

defmodule Backend.DeleteOldForgotPasswordRequestsWorker do
  use GenServer
  
  alias Backend.Repo
  alias Backend.ForgottenPasswordRequest

  @interval 6 * 1000
  #@interval 24 * 60 * 60 * 1000# In 24 hours
  
  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Process.send_after(self(), :work, @interval ) 
    {:ok, state}
  end

  def handle_info(:work, state) do
    
    now = Ecto.DateTime.utc() 
    
    #TODO: put -30 in constant
    Repo.delete_all(
      from r in ForgottenPasswordRequest, 
      where: datetime_add(^now, -30, "day") > r.inserted_at
    )

    # Start the timer again
    Process.send_after(self(), :work, @interval) 

    {:noreply, state}
  end
end