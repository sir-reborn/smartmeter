import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationCard extends StatefulWidget {
  const LocationCard({
    super.key,
    required this.longitude,
    required this.latitude,
  });

  final double? longitude;
  final double? latitude;

  @override
  State<LocationCard> createState() => _LocationCardState();
}

class _LocationCardState extends State<LocationCard> {
  String _address = 'Fetching address...';
  bool _isLoading = true;
  double? _lastLatitude;
  double? _lastLongitude;
  String get address => _address;
  @override
  void initState() {
    super.initState();
    _lastLatitude = widget.latitude;
    _lastLongitude = widget.longitude;
    _fetchAddress();
  }

  @override
  void didUpdateWidget(LocationCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if coordinates have actually changed
    if (widget.latitude != _lastLatitude ||
        widget.longitude != _lastLongitude) {
      _lastLatitude = widget.latitude;
      _lastLongitude = widget.longitude;
      _fetchAddress();
    }
  }

  Future<void> _fetchAddress() async {
    // Skip if coordinates are null
    if (widget.latitude == null || widget.longitude == null) {
      setState(() {
        _address = 'Location data not available';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _address = 'Fetching address...';
    });

    const apiKey = 'be37ad2caa894da39ac8fe187b19a2e0';
    final url = Uri.parse(
      'https://api.opencagedata.com/geocode/v1/json?q=${widget.latitude!}+${widget.longitude!}&key=$apiKey',
    );

    try {
      final response = await http.get(url);

      if (!mounted) return; // Check if widget is still in the tree

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'].isNotEmpty) {
          final formatted = data['results'][0]['formatted'];
          setState(() {
            _address = formatted ?? 'Address not available';
            _isLoading = false;
          });
        } else {
          setState(() {
            _address = 'Address not found';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _address = 'Failed to fetch address (HTTP ${response.statusCode})';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _address = 'Error: ${e.toString().replaceAll(apiKey, 'REDACTED')}';
        _isLoading = false;
      });
    }
  }

  String _formatCoordinate(double? coord) {
    if (coord == null) return 'N/A';
    return coord.toStringAsFixed(6);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.all(Radius.circular(size.width / 40)),
      ),
      width: size.width,
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width / 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: size.width / 20,
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    child: Icon(
                      CupertinoIcons.location_solid,
                      color: Colors.black.withOpacity(0.6),
                      size: size.width / 12,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    _formatCoordinate(widget.latitude),
                    style: GoogleFonts.poppins(
                      fontSize: size.width / 19,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    _formatCoordinate(widget.longitude),
                    style: GoogleFonts.poppins(
                      fontSize: size.width / 19,
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: size.width,
                child: Text(
                  'Location: ${_isLoading ? 'Loading...' : _address}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
