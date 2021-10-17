using Plots, LaTeXStrings
function neighbors(network_, i,j, dim)
  neighbors_dict=DataStructures.OrderedDict()
  if i+1!=dim+1
    neighbors_dict[[i+1,j]]=network_[i+1,j]
  end
  if i-1!=0
    neighbors_dict[[i-1,j]]=network_[i-1,j]
  end
  if j+1!=dim+1
  neighbors_dict[[i,j+1]]=network_[i,j+1]
  end
  if j-1!=0
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
    for item in coordinat_arr
      network_[item[1],item[2]]=OnEntries_dict[item] #changing the attributes in network_, respectively
    end
  return network_,OnEntries_dict
end

function InitialNetwork(network_, dim,p)
  neighbors_dict=neighbors(network_, rand(1:dim), rand(1:dim),dim) #choosing a random entry and giving the neigbhors
  println(neighbors_dict)#####
  network_, OnEntries_dict=on_or_block(network_, dim, neighbors_dict,p)
  return network, OnEntries_dict
end

dim=10
p=0.7
network_=zeros(Int,dim,dim)
network, OnEntries_dict=InitialNetwork(network_, dim,p)
if length(OnEntries_dict)>0
  for entry in OnEntries_dict
    neighbors_list=neighbors(network_,findall(x->x==10,l)[][1],findall(x->x==10,l)[][2], dim)
    for i in neighbors_list
      OnEntries=on_or_block(network_,dim,i )
      if length(OnEntries)>0
        continue
      else
        break
      end
    end
  end
end
