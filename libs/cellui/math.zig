const Self = @This();

pub const Matrix = struct {
    pub fn ortho(left: f32, right: f32, bottom: f32, top: f32) [4][4]f32 {
        var matrix: [4][4]f32 = [_][4]f32{[_]f32{0} ** 4} ** 4;
        matrix[0][0] = 2 / (right - left);
        matrix[1][1] = 2 / (top - bottom);
        matrix[2][2] = -1;
        matrix[3][0] = -(right + left) / (right - left);
        matrix[3][1] = -(top + bottom) / (top - bottom);
        matrix[3][3] = 1;
        return matrix;
    }
};
