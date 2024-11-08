// MonitorCow - CTCL 2024
// File: monitorcow-n156kme-gna_mdf.scad
// Purpose: Case design, optimized for wood carving
// Created: October 18, 2024
// Modified: November 8, 2024

// Units - mm
// X - Width
// Y - Length
// Z - Height

// Accepted values:
// "base" - Everything else
// "lcdmount" - Display mount
// "lcdcover" - Display cover layer
// "all" - Show everything
// "allexp" - Show everything, exploded view
show = "base";
exp_dist = 75;

// Dimensions
// 215mm display + 10mm display PCB area + 10mm for cable ; 2.6mm for display + 2mm double-sided tape
lcd_dims = [350, 215 + 10 + 10, 2.6 + 2];
// Distance between connector middle and the outer right side of the display
lcd_conn_from_right = 120;
// Distances between the outer dimension of the lens to the LCD active area
lcd_aa_dist_right = 2.5;
lcd_aa_dist_left = 2.5;
lcd_aa_dist_bottom = 17 + 7;
lcd_aa_dist_top = 2.5;

case_bottom_height = 2.5;
// Distance between the case bottom layer and the bottom of the display mount
case_internal_height = 9;

// Walls that the display mount rests on
case_inner_wall_width = 10;

// Outer structural wall of the case
// WARNING: This variable changes the size of the case
case_outer_wall_width = 5;
// Size of the posts that the display mount bolts to
// WARNING: This variable changes the size of the case and LCD mount
case_post_size = 10;

disp_edge_width = case_post_size;
disp_cover_height = 2;
disp_base_height = 2;
disp_conn_cutout_width = 30;
disp_conn_cutout_length = 50;

// PCB parameters
pcb_width = 60;
pcb_length = 102;
pcb_thickness = 1;

// PCB mounting hole offsets
pcb_mount_tl = [23,-3];
pcb_mount_tr = [-16,-3];
pcb_mount_bl = [12,3];
pcb_mount_br = [-16,3];

// Button PCB parameters
pcb2_width = 51;
pcb2_length = 28;

// Distance between PCBs
pcb_sep_dist = 10;

// Standoff parameters
// length of both sides
pcb_standoff_base_size = 6;
pcb_standoff_height = 3;
pcb_standoff_od = 4;

case_mount_standoff_height = 3;
case_mount_standoff_od = 4.5;

// Bolt diameter + tolerance
bolt_dia = 3 + 0.6;

// Support count
support_width = case_inner_wall_width;
disp_y_axis_supports = 2;

// == Variable Assignment Section ==
// Height of the mount part
lcd_mount_height = disp_base_height + lcd_dims[2];

box_height = case_bottom_height + case_internal_height + lcd_mount_height;
box_width = lcd_dims[0] + (case_post_size * 2) + (case_outer_wall_width * 2);
box_length = lcd_dims[1] + (case_post_size * 2) + (case_outer_wall_width * 2);

// Total size of the case
box_dims = [box_width, box_length, box_height];
// Size of the inside part of the box without display rest walls
box_total_inner_size = [lcd_dims[0] + (case_post_size * 2), lcd_dims[1] + (case_post_size * 2), box_height];
// Size of the inside part of the box with display rest walls
// No wall right due to IO
box_inner_size = [lcd_dims[0] + ((case_post_size * 2) - case_inner_wall_width), lcd_dims[1] + ((case_post_size * 2) - (case_inner_wall_width * 2)), box_height];

// 3D size of posts
post_dims = [case_post_size, case_post_size, case_internal_height];

// Case bolt center locations
case_bolt_centers = [
    [case_outer_wall_width, case_outer_wall_width, case_bottom_height] + [(case_post_size / 2), (case_post_size / 2), post_dims[2] - case_mount_standoff_od],
    [case_outer_wall_width + box_total_inner_size[0] - case_post_size, case_outer_wall_width, case_bottom_height] + [(case_post_size / 2), (case_post_size / 2), post_dims[2] - case_mount_standoff_od],
    [case_outer_wall_width, case_outer_wall_width + box_total_inner_size[1] - case_post_size, case_bottom_height] + [(case_post_size / 2), (case_post_size / 2), post_dims[2] - case_mount_standoff_od],
    [case_outer_wall_width + box_total_inner_size[0] - case_post_size, case_outer_wall_width + box_total_inner_size[1] - case_post_size, case_bottom_height] + [(case_post_size / 2), (case_post_size / 2), post_dims[2] - case_mount_standoff_od]
];

// == Object Drawing Section ==
module base() {
    module standoff() {
        translate([0, 0, 0]) {
            difference() {
                cube([pcb_standoff_base_size, pcb_standoff_base_size, pcb_standoff_height]);
//                translate([(pcb_standoff_base_size / 2), (pcb_standoff_base_size / 2), -1]) { 
//                    cylinder(r=pcb_standoff_od / 2, h=pcb_standoff_od + 2, $fn=6);
//                }
            }
        }
    }
    difference() {
        union() {
            difference() {
                cube(box_dims);
                // Cutout for internals
                translate([case_outer_wall_width + case_inner_wall_width, case_outer_wall_width + case_inner_wall_width, case_bottom_height]) {
                    cube(box_inner_size);
                }
                // Cutout for display mount
                translate([case_outer_wall_width, case_outer_wall_width, case_bottom_height + case_internal_height]) {
                    cube([lcd_dims[0] + (case_post_size * 2), lcd_dims[1] + (case_post_size * 2), box_height]);
                }
            }
            // With 0 Y = Bottom, 0 X = Left
            // Bottom Left Post
            translate([case_outer_wall_width, case_outer_wall_width, case_bottom_height]) {
                cube(post_dims);
            }
            // Bottom Right Post
            translate([case_outer_wall_width + box_total_inner_size[0] - case_post_size, case_outer_wall_width, case_bottom_height]) {
                cube(post_dims);
            }
            // Top Left Post
            translate([case_outer_wall_width, case_outer_wall_width + box_total_inner_size[1] - case_post_size, case_bottom_height]) {
                cube(post_dims);
            }
            // Top Right Post
            translate([case_outer_wall_width + box_total_inner_size[0] - case_post_size, case_outer_wall_width + box_total_inner_size[1] - case_post_size, case_bottom_height]) {
                cube(post_dims);
            }
        }
        // PCB connector cutout
        translate([box_dims[0] - case_outer_wall_width - 1, case_outer_wall_width + case_post_size, case_bottom_height + pcb_standoff_height - 2]) {
            cube([case_outer_wall_width + 2,pcb_width,20]);
        }
        // Button PCB cutout
        translate([box_dims[0] - case_outer_wall_width - 1, case_outer_wall_width + case_post_size + pcb_width + pcb_sep_dist, case_bottom_height + pcb_standoff_height - 2]) {
            cube([case_outer_wall_width + 2,pcb2_width,20]);
        }
    }
    // Supports
    if (disp_y_axis_supports > 0) {
        for (a =[0:disp_y_axis_supports]) {
            
            translate([(((box_dims[0] / (disp_y_axis_supports + 1))) - support_width) * a,0,case_bottom_height]) {
                cube([support_width,box_dims[1],case_internal_height]);
            }
        }
    }
    // PCB standoffs
    // Subtracting x by "case_outer_wall_width" is omitted from the following to have the connectors somewhat flush with the side of the case
    translate([box_dims[0] - pcb_length, case_outer_wall_width + case_post_size, case_bottom_height]) {
        // Bottom Left
        translate([0, 0, 0] + pcb_mount_bl) {
            standoff();
        }
        // Bottom Right
        translate([pcb_length - pcb_standoff_base_size, 0, 0] + pcb_mount_br) {
            standoff();
        }
        // Top Left
        translate([0, pcb_width - pcb_standoff_base_size, 0] + pcb_mount_tl) {
            standoff();
        }
        // Top Right
        translate([pcb_length - pcb_standoff_base_size, pcb_width - pcb_standoff_base_size, 0] + pcb_mount_tr) {
            standoff();
        }
    } 
    
    // Button PCB standoff
    // It is a flat platform as the button panel would be double-sided-taped to the case instead of using bolt mounts due to its small size
    translate([box_dims[0] - case_outer_wall_width - pcb2_length, case_outer_wall_width + case_post_size + pcb_width + pcb_sep_dist, case_bottom_height - 2]) {
        cube([pcb2_length, pcb2_width, pcb_standoff_height]);
    }    
}

module lcdmount() {
    difference() {
        translate([case_outer_wall_width, case_outer_wall_width, 0]) {
            difference() {
                cube([box_total_inner_size[0], box_total_inner_size[1], lcd_mount_height]);
                translate([case_post_size, case_post_size, disp_base_height]) {
                    // Add 1 to prevent z fighting effects
                    cube(lcd_dims + [0,0,1]);
                }
                conn_cutout_dist = 
                    box_total_inner_size[0] - 
                    case_post_size -
                    (lcd_conn_from_right - (disp_conn_cutout_width / 2));
                
                // Once again add -1 to height for z fighting
                translate([conn_cutout_dist, case_post_size, -1]) {
                    // Connector cutout 
                    // Then add back 2mm to height
                    cube([disp_conn_cutout_width, disp_conn_cutout_length, disp_base_height + 2]);
                }   
            }
        }
        for (pos = case_bolt_centers) {
            translate([pos[0], pos[1], -1]) {
                cylinder(r = bolt_dia / 2, h = lcd_mount_height + 2, $fn=360);
            }
        }
    }
    
    translate([box_dims[0] - case_outer_wall_width, case_outer_wall_width + case_post_size, 0]) {
        cube([case_outer_wall_width,pcb_width,lcd_mount_height]);
    }
    translate([box_dims[0] - case_outer_wall_width, case_outer_wall_width + case_post_size + pcb_width + pcb_sep_dist, 0]) {
        cube([case_outer_wall_width,pcb2_width,lcd_mount_height]);
    }
}

module lcdcover() {
    difference() {
        cube([box_dims[0], box_dims[1], disp_cover_height]);
        cutout_width = box_dims[0] - (case_post_size * 2) - (case_outer_wall_width * 2) - lcd_aa_dist_right - lcd_aa_dist_left;
        cutout_length = box_dims[1] - (case_post_size * 2) - (case_outer_wall_width * 2) - lcd_aa_dist_top - lcd_aa_dist_bottom;
        left_distance = lcd_aa_dist_left + case_post_size + case_outer_wall_width;
        bottom_distance = lcd_aa_dist_bottom + case_post_size + case_outer_wall_width;
        translate([left_distance, bottom_distance, -1]) {
            cube([cutout_width, cutout_length, disp_cover_height + 2]);
        }
        for (pos = case_bolt_centers) {
            translate([pos[0], pos[1], -1]) {
                cylinder(r = bolt_dia / 2, h = lcd_mount_height + 2, $fn=360);
            }
        }
    }
}




if (show == "base") {
    base();
}

if (show == "lcdmount") {
    lcdmount();
}

if (show == "lcdcover") {
    lcdcover();
}

if (show == "all") {
     base();
    translate([0, 0, case_bottom_height + case_internal_height]) {
        lcdmount();
    }
    translate([0, 0, case_bottom_height + case_internal_height + disp_base_height + lcd_dims[2]]) {
        lcdcover();
    }
}

if (show == "allexp") {
    base();
    translate([0, 0, case_bottom_height + case_internal_height + exp_dist]) {
        lcdmount();
    }
    translate([0, 0, case_bottom_height + case_internal_height + disp_base_height + lcd_dims[2] + (exp_dist * 2)]) {
        lcdcover();
    }
}

