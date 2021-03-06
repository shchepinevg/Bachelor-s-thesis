#�����������
PSO <- R6Class("PSO",
               inherit = Optim,
               public = list(
                 initialize = function(N,func) {
                   dim = func$get_dim()$continuous +  func$get_dim()$discrete
                   super$initialize(N,func,dim)
                   #������������ ����������� ���������. ��� ���������� - ���������� ��������������� �������� 
                   private$params = list(     discrete = list(lower = c(10*dim,1),
                                                              default = c(get_default_N_pop(dim,N),2),
                                                              upper = c(N/2,5),
                                                              name = c("N_pop","accurance")),
                                              continuous   = list(lower = c( -2, -4, -4),
                                                                  upper = c( 2, 4, 4),
                                                                  default = c(0.7298,1.49618,1.49618),
                                                                  name = c("inertion", "selfCoof", "globalCoof")))
                   
                   private$dim = dim
                   private$N = N
                   private$func = func
                 }
               ),
               private = list(
                 name = "Particle swarm optimization",
                 pso = function (target_func,params,upper,lower,default_params,accur){
                   dimension = params[1] #��������� ����������� (����������� ������������ ������ �������)
                   pop_size = params[2] #���������� ������� ������
                   inertion = params[3] #����������� �������
                   alpha = params[4] #������� ����������� ������������ ������� �������� ������
                   beta = params[5] #������� ����������� ����������� ������� ��������
                   max_velocity = params[6] #������������ �������� ������
                   iter_counter = params[7] #���������� ��������
                   accuracy = accur #�������� ��������
                   #������������ �������������� ��� �������������
                   coords = matrix(0, nrow = dimension, ncol = pop_size) #������� ������� ��������� �������
                   results = matrix(0, nrow = 1, ncol = pop_size) #������� ������� �������� ������� �������
                   velocity = matrix(0,  nrow = dimension, ncol = pop_size) #������� ��������� �������
                   best_coords = matrix(0, nrow = dimension, ncol = pop_size) #������� ������ ��������� �������
                   best_results = matrix(0, nrow = 1, ncol = pop_size) #������� ������ �������� ������� ������� (������-������)
                   best_global_coords = matrix(0, nrow = dimension, ncol = 1) #������� ������ ���������� ��������� (������-�������)
                   best_global_result = NA #������ ���������� �������� �������
                   #�������������
                   for (i in 1:pop_size){
                     if(is.null(default_params)){
                       for(j in 1:dimension){
                         default_params = runif(n = dimension, min = lower[j], max = upper[j])
                       }
                     }
                     coords[,i] = default_params
                     for(j in 1:dimension){
                       coords[j, i] = runif(n = 1, min = lower[j], max = upper[j]) #������������� ��������� ���������
                     }
                     rest = target_func(coords[, i])
                     if(is.list(rest)){
                       results[1, i] = rest$value
                     } else {
                       results[1, i] = rest
                     }  
                   }
                   best_global_result = min(results[1, ]) #����� ���������� ����������� �������� ������� �� ������� ��������
                   best_global_coords[, 1] = coords[,which.min(results[1, ])] #����� ��������� ���������� ���������
                   best_coords = coords #����� ��������� ��������� � �������� ������
                   best_results = results #����� ��������� �������� ������� � �������� ������
                   #������
                   for (k in 1:iter_counter){
                     velocity_sum = 0 #��������� ����� �������� ��������
                     for (i in 1:pop_size) {
                       velocity[, i] = inertion*velocity[, i] + alpha*(best_coords[, i] - coords[, i])*runif(1, 0, 1) +
                         beta*(best_global_coords[, 1] - coords[, i])*runif(1, 0, 1)
                       for(j in 1:dimension){
                         if (velocity[j, i] > max_velocity){
                           velocity[j, i] = max_velocity
                         }
                         if (velocity[j, i] < -max_velocity){
                           velocity[j, i] = -max_velocity
                         }
                         dx = coords[j, i] + velocity[j, i]
                         if(lower[j]<dx&&upper[j]>dx){
                           coords[j, i] = dx
                         } else {
                           velocity[j, i] = -velocity[j, i]
                           dx = coords[j, i] + velocity[j, i]
                           if(lower[j]<dx&&upper[j]>dx){
                             coords[j, i] = dx
                           } else {
                             velocity[j, i] = 0    
                           }
                         }
                       }
                       rest = target_func(coords[, i])
                       if(is.list(rest)) {
                         results[1, i] = rest$value
                       } else {
                         results[1, i] = rest
                       }
                       if(results[1, i] < best_results[1, i]){
                         best_results[1, i] = results[1, i]
                         best_coords[, i] = coords[,i] 
                       }
                       if(results[1, i] < best_global_result){
                         best_global_result = results[1, i]
                         best_global_coords[, 1] = coords[, i]
                       }
                       velocity_sum = velocity_sum + sqrt(sum(velocity[, i]*velocity[, i]))
                     }
                     if ((velocity_sum/pop_size) < accuracy){
                       break #��������� �����, ���� ������� ����� ��������� ������ �������� ��������
                     }
                   }
                   return (list(value = best_global_result, solution = best_global_coords))
                 },
                 optim = function(continuous,discrete,point){
                   
                   maxVel = 0.3*sqrt(sum((private$func$get_Pcontinuous()$upper-private$func$get_Pcontinuous()$lower)^2))
                   if (private$func$get_dim()$discrete == 0){
                     lower_disc = NULL
                     upper_disc = NULL
                     fitness = function(x){
                       y = private$func$get_fitness()(x,NULL);return(y)}
                     
                   } else {
                     lower_disc = private$func$get_Pdiscrete()$lower-0.49
                     upper_disc = private$func$get_Pdiscrete()$upper+0.49
                     fitness = function(x){
                       continuous = x[1:private$func$get_dim()$continuous]
                       discrete = round(x[-(1:private$func$get_dim()$continuous)])
                       y = private$func$get_fitness()(continuous,discrete);return(y)}
                     
                   }
                   if (private$func$get_dim()$continuous == 0){
                     lower = lower_disc
                     upper = upper_disc
                   } else {
                     lower = c(private$func$get_Pcontinuous()$lower,lower_disc) 
                     upper = c(private$func$get_Pcontinuous()$upper,upper_disc)
                   }
                   res <-  private$pso(target_func = fitness,
                                params = c(private$dim,# �����������
                                           c(discrete[1],continuous),#��������� ���������� �������������
                                           maxVel,#������������ ��������
                                           private$N/discrete[1]),#����� ��������
                                lower = lower, 
                                upper = upper,  
                                default_params = c(private$func$get_Pcontinuous()$default,private$func$get_Pdiscrete()$default),
                                accur = 10^-discrete[2]
                   )
                   pos = as.numeric(res$solution)
                   pos[-(1:private$func$get_dim()$continuous)] = round(pos[-(1:private$func$get_dim()$continuous)])
                   result = list(pos = pos,value = res$value)
                   return(result)
                 }
               )
)