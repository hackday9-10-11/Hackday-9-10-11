

from math import *
import simplejson

# http://stackoverflow.com/questions/4913349/haversine-formula-in-python-bearing-and-distance-between-two-gps-points
def haversine(lat1, lon1, lat2, lon2):
    """
    Calculate the great circle distance between two points 
    on the earth (specified in decimal degrees)
    """
    # convert decimal degrees to radians 
    lon1, lat1, lon2, lat2 = map(radians, [lon1, lat1, lon2, lat2])
    # haversine formula 
    dlon = lon2 - lon1 
    dlat = lat2 - lat1 
    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    c = 2 * atan2(sqrt(a), sqrt(1-a)) 
    km = 6367 * c
    return km * (1.0 / 1.609344)
    


f = file('at-trail.geojson')
d = simplejson.load(f)
features = d['features']

outFileHandle = open("at-tracks.json", "w")
    

last_point = None
agg_distance = 0
trail_points = list()
pid = 0
for feature in features:
	geo = feature['geometry']
	coords = geo['coordinates']
	for line in coords:
	    for point in line:
	        if not last_point:
	            last_point = point

	        longitude = point[0]
	        latitude = point[1]
	        delta = haversine(latitude, longitude, last_point[1], last_point[0])
	        agg_distance += delta
	        p_json = dict(id = pid, latitude=latitude, longitude=longitude, delta_dist = delta, agg_dist_from_south = agg_distance)
	        trail_points.append(p_json)
	        last_point = point
	        pid += 1

outFileHandle.write(simplejson.dumps(trail_points, indent=4))	        
outFileHandle.close()