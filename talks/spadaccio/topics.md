Considerations in Scaling Large Web Systems
===========================================

This presentation has been authored by Cian Synnott (cian@emauton.org); I am
re-using his slides.

The talk will be delivered as a Google Docs presentation over Hangouts, so I
am putting here the list of topics that will be treated during the talk.

The slides don't contain much text; the important portion of the talk is..
well.. talking. :) So there isn't much to put here. Anyway, here it goes.

Environment
-----------

1. Big numbers.
1. Speed matters.
1. Many rconnected machines.
1. Failure is normal.
1. Automation is ubiquitous.

Terminology
-----------

server: individual process or binary running on a machine
machine: physical or virtual piece of hardware running an operating system
qps: queries per second, measurement unit for the traffic volume

Fundamentals
------------

1. Make educated guesses.
1. Keep it simple.
1. Be transparent.

Example
-------

Image server, used to upload images and serve thumbnails.

Complex design: single server to handle both types of requests.

The traffic has 2 inherent components:

1. Image upload (low qps, long duration)
1. Thumbnail serving (hight qps, short duration)

KISS: split into an upload server and a thumbnail server

Transparency:

* Traditional items: log requests, break by error code (2xx, 4xx etc), process
  logs (ERROR, WARNING etc..)

* Increase transparency:
  * provide simple exported metrics (counters or key/value maps), to be used
    by external monitoring agents;
  * provide debugging/inspection URLs (e.g. Apache server-status)
  * explicit statement of health (OK and ready to serve)

Composition
-----------

Seek balance: 2-tier can lead to SPOF, distribute processing across several
tiers.

Replicate everything: horizontal vs. vertical scaling; careful development
should drive the direction towards horizontal scaling, easier to obtain and
offering better reliability through redundancy (N + 2).

Question state: stateless servers, externalized shared state (if really
required).

Divide state: scale through sharding.

Seek consensus: 

* CAP Theorem: networked shared-data system can have at most two of the
  following properties:
  
  * C: Consistency (having a single up-to-date copy of the data)
  * A: high Availability of data for updates
  * P: tolerance to network Partitions

E.g., Paxos sacrifices A for CP (in case of partitions, on one side of the
partition it will not be possible to issue updates.

Coordination: e.g., have a master process, outside the serving path, that
coordinates activities.

Abstraction
-----------

1. Build services.
1. Extract services.

Change
------

1. Maintain flexibility.
1. Anticipate the future.
   * Track historical metrics, plan launches, prepare for bottlenecks.
1. Check the user experience.
