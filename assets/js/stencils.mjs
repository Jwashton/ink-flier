import { withState, fillPath } from "./canvas.mjs";

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
  }
};

export default Stencils;
