using Plots, LaTeXStrings,DataStructures
function neighbors(network_, i,j, dim)
  println(i,j)
  neighbors_dict=DataStructures.OrderedDict()
  if i+1!=dim+1 && network_[i+1,j]==0
    neighbors_dict[[i+1,j]]=network_[i+1,j]
  end
  if i-1!=0 && network_[i-1,j]==0
    neighbors_dict[[i-1,j]]=network_[i-1,j]
  end
  if j+1!=dim+1 && network_[i,j+1]==0
  neighbors_dict[[i,j+1]]=network_[i,j+1]
  end
  if j-1!=0 && network_[i,j-1]==0
    neighbors_dict[[i,j-1]]=network_[i,j-1]
  end
  return neighbors_dict
end

function on_or_block(network_,dim,neighbors_dict ,p)
  OnEntries_dict=DataStructures.OrderedDict()
  for key in keys(neighbors_dict)
    if p>rand()
      OnEntries_dict[key]=1 #On
    else
      OnEntries_dict[key]=-1 #Block
    end
  end
  coordinate_arr=collect(keys(OnEntries_dict))
  for item in coordinate_arr
    network_[item[1],item[2]]=OnEntries_dict[item] #changing the attributes in network_, respectively
    if OnEntries_dict[item]==-1
      delete!(OnEntries_dict,item)
    end
  end
  return network_,OnEntries_dict
end

function InitialNetwork(network_, dim,p)
  network_[rand(1:dim),rand(1:dim)]=1
  neighbors_dict=neighbors(network_, findall(x->x==1,network_)[1][1], findall(x->x==1,network_)[1][2],dim) #choosing a random entry and giving the neigbhors
  println(neighbors_dict)#####
  network_, OnEntries_dict=on_or_block(network_, dim, neighbors_dict,p)
  return network_, OnEntries_dict
end

dim=10
p=0.7
network_=zeros(Int,dim,dim)
network_, OnEntries_dict=InitialNetwork(network_, dim,p)
#if length(OnEntries_dict)>0
for entry in keys(OnEntries_dict)
  neighbors_dict=neighbors(network_, entry[1],entry[2], dim)
  network_,OnEntries_dict=on_or_block(network_,dim,neighbors_dict ,p)
  if length(OnEntries_dict)>0
    continue
  else
    break
  end
end
