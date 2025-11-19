Q1 • K8s Networking

from Pod A

http://www.demo.boost.tv/ → Failure

This seems to be an external domain , pod A would not be able to reach it unless there's egress rules in place and there's an Internet Gateway is attached to the VPC (where Pod A is located)

http://backend.demo.boost.tv/api/v1/health → Failure

similarly , This seems to be an external domain , pod A would not be able to reach it unless there's egress rules in place and there's an Internet Gateway is attached to the VPC (where Pod A is located)

http://backend-streamlabros-demo.backend.svc.cluster.local:4000/api/v1/health → Success

this seems to be a cluster IP (in backend namespace within the same cluster) , as long as the pod that serves this cluster IP is running , we see success.

http://frontend-streamlabros-demo.frontend.svc.cluster.local:3000/ → Success

similarly , this seems to be a cluster IP (in backend namespace within the same cluster) , as long as the pod that serves this cluster IP is running , we see success.


Q2 • Overlapping Networks
What are overlapping networks, and the most cost-effective way to remove them in a
multi-VPC?

This can happen when two or VPC (or the subnets within) use the same CIDR/IP range . As long as there's no direct conectivity/routing b/w them .
But this can cause conflicts when routing b/w the two VPCs . In that scenario, we can reallocate IP ranges among the VPCs and go on with networking.

Q3 • Rollback • Production K8s
Design a rollback strategy for production Kubernetes. how to balance speed, reliability, and data
consistency.

Speed : By ensuring single click or command rollback strategy and reverting to last known build versions

reliability: this can be achieved by ensuring we've health checks . Alerts can also be in place to notify the devops about the progressive delivery.

Data consistency: this can be achieved by ensuring backward compatibility of all code (app and the DB versions).

Q4 • Logging Architecture
Why is sending logs directly from pods to the log server a bad idea. when does a log aggregator
help, and when can it be skipped.

sending logs to the log server from pods directly is a bad idea because Pods are temporary/ephemeral and there's chances of losing logs while pods crash/restart and it's not scalable.

Log aggregators do collect logs at Node level(in most cases) and are easy to scale . Also , they can help us index/enrich/transform logs in transit . they can be skipped when the deployment is simple(small cluster) or if it's a single node application.

Q5 • Autoscaling Strategy
Why use Cluster Autoscaler if you have Karpenter. when is Karpenter not a good fit.

karpenter is open-source but AWS is the main contributor and so it's optimized for EKS/AWS workloads . It may not be the best option for GKE or AKS.

Q6 • Certificates for Private Services
How to get public TLS for internal-only services on private IPs like 10.0.27.99. give two
methods and trade-offs.

Method 1:

Deploy a reverse proxy (with public DNS) infront of the private workload . the proxy forwards traffic and offloads TLS.

Tradeoff : The reverse proxy is exposed to the Internet anyways.

Method 2 : 

Get a private CA (own CA using AWS cert manager , for instance) and then sign certs for this IP and all clients will use the CA's root cert to trust the service at this IP.
