AutoScale the EKS-Cluster :

steps: You need to follow is =======>

1) Create an IAM role and attach autoscaling policies to the role name it according
2) Create cluster using EKSCTL utility, you will get the file name like in this repo: **"create-cluster.yaml"** after cluster creation attach the created role-policy to control-plane-IAM_ROLE and managed node groups-IAM_ROLE
3) Go to the EKS cluster console ==> in that managed node group edit managed node group add two tags in that tag section
4)
   k8s.io/cluster-autoscaler/<cluster-name>	owned ,
   k8s.io/cluster-autoscaler/enabled	      true
    So that autoscaler deployment will communicate ASG(Auto-Scaling-Grup) to scale-up and scale-down the instances
5) Create Auto-Scaler deployment, You can get the manifest in this repo ex: **"cluster-autoscaler-auto-discover.yaml"** manifest file
6) Add this annotate to your deployment kubectl -n kube-system annotate deployment.apps/cluster-autoscaler cluster-autoscaler.kubernetes.io/safe-to-evict="false"
7) Make some changes to that according like In deployments in command sections add **"cluster-name of yours**" and add below points
     "--balance-similar-node-groups, 
     --skip-nodes-with-system-pods=false "
8) create your deployment according and set the replicas=25ormore and see the magic, how nodes will autoscale according.
9) cool-down will take 5-10mins for nodes to scale down after replicas will come down.
10) Make sure that **clusterversion =====> ex:(1.26) matches to autoscaler-container-version ======>ex(1.26)**, or else it wont work according
   
