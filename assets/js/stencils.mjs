import { withState, fillPath } from "./util/canvas.mjs";

const TWO_PI = 2 * Math.PI;

export const Stencils = {
  square(ctx, { x, y, size, fill }) {
    withState(ctx, context => {
      context.fillStyle = fill;
      context.fillRect(x, y, size, size);
    });
  },

  circle(ctx, { x, y, radius, fill }) {
    fillPath(ctx, fill, context => {
      context.arc(x, y, radius, 0, TWO_PI);
    });
  },

  car(ctx, { x, y, size, fill }) {
    const half_size = size / 2;
    const wing_tip_distance = size / 4;
    const y_tip = y - half_size;
    const y_tail = y_tip + size;
    const y_center_indent = wing_tip_distance;

    fillPath(ctx, fill, context => {
      context.moveTo(x, y_tip);
      context.lineTo(x + half_size, y_tail - wing_tip_distance);
      context.lineTo(x + half_size, y_tail);
      context.lineTo(x, y_tail - y_center_indent);
      context.lineTo(x - half_size, y_tail);
      context.lineTo(x - half_size, y_tail - wing_tip_distance);
      context.closePath();
    });
  }
};

export default Stencils;
