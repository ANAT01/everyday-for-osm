#!/usr/bin/python3


import json
import decimal
import os

location = '../maps/'
print(open(location + '72-16-P_VILAGES.geojson', 'r').read())


def parsefloat(s):
    return decimal.Decimal(str(round(float(s), 2)))

geojson = json.loads(open(location + '72-16-P_VILAGES.geojson', 'r').read())





for geometry in geojson['features']:
    # Get name of locality and make path
    locality = ''
    locality = geometry['properties']['NAME'].replace('.', '').split(' ')
    locality = locality[1] + '_' + locality[0]

    # Make new geojson file with one locality
    print(geometry)
    newgeojson = '{"type": "FeatureCollection","features": ['
    newgeojson += json.dumps(geometry, ensure_ascii=False) + ']}'
    # make geojson pretty print
    newgeojson = json.dumps(json.loads(newgeojson, parse_float=float), indent=2, sort_keys=True, ensure_ascii=False)
    # Save geojson
    print(location + locality)
    if not os.path.isdir(location + locality):
        os.mkdir(location + locality)
    with open(location + locality + '/' + locality + '.geojson', 'w') as f:
        f.write(newgeojson)
        f.close()

    # Make boundary box
    latmax = lonmax = float()
    latmin = lonmin = float('inf')
    for latlon in geometry['geometry']['coordinates'][0][0]:
        if latmax < latlon[1]:
            latmax = latlon[1]
        if latmin > latlon[1]:
            latmin = latlon[1]
        if lonmax < latlon[0]:
            lonmax = latlon[0]
        if lonmin > latlon[0]:
            lonmin = latlon[0]
    # lat-lon format
    bbox = u'{0},{1},{2},{3}'.format(latmin, lonmin, latmax, lonmax)
    print(bbox)
    with open(location + locality + '/' + 'bbox', 'w') as f:
        f.write(bbox)
        f.close()
    # lon-lat fromat
    bbox = u'{1},{0},{3},{2}'.format(latmin, lonmin, latmax, lonmax)
    print(bbox)
    with open(location + locality + '/' + 'bbox_lonlat', 'w') as f:
        f.write(bbox)
        f.close()


        # print(newgeojson)
        #  print(geometry['properties']['NAME'])
