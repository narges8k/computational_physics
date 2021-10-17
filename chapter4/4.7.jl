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
function InitialNetwork(network_, dim,p)
  neighbors_dict=neighbors(network_, rand(1:dim), rand(1:dim),dim)
  println(neighbors_dict)#####
  network_, OnEntries_dict=on_or_block(network_, dim, neighbors_dict,p)
end
function on_or_block(network_,dim,neighbors_dict ,p)
  OnEntries_dict=DataStructures.OrderedDict()
  for key in keys(neighbors_dict)
    if p>rand()
      OnEntries_dict[key]=1
    else
      OnEntries_dict[key]=-1
    end
    coordinate_arr=collect(keys(OnEntries_dict))
    for item in coordinat_arr
      network_[item[1],item[2]]=OnEntries_dict[item]
    end
  return  network_,OnEntries_dict
end

dim=10
p=0.7
network_=zeros(Int,dim,dim)
OnEntries=InitialNetwork(network_, dim,p)
if length(OnEntries)>0
  for entry in OnEntries
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
