import { withState, fillPath, strokePath } from "./canvas.mjs";

const TWO_PI = 2 * Math.PI;

export const Stencils = {
  square(ctx, { x, y, size, fill }) {
    withState(ctx, context => {
      context.fillStyle = fill;
      context.fillRect(x, y, size, size);
    });
  },

  circle(context, { x, y, radius, fill, stroke, strokeSize }) {
    withState(context, ctx => {
      if (stroke) {
        ctx.strokeStyle = stroke;
      }
      if (strokeSize) {
        ctx.lineWidth = strokeSize;
      }
      if (fill) {
        ctx.fillStyle = fill;
      }

      ctx.beginPath();
      ctx.arc(x, y, radius, 0, TWO_PI);

      if (stroke) {
        ctx.stroke();
      }

      if (fill) {
        ctx.fill();
      }
    });
  },

  vector(context, { vector, origin, stroke, strokeSize }) {
    withState(context, ctx => {
      ctx.strokeStyle = stroke;
      ctx.lineWidth = strokeSize;
      ctx.beginPath();
      ctx.moveTo(origin.x, origin.y);
      ctx.lineTo(origin.x + vector.x, origin.y + vector.y);
      ctx.stroke();
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
  },

  plus(ctx, { x, y, size, stroke, strokeSize }) {
    const half_size = size / 2;

    withState(ctx, context => {
      context.strokeStyle = stroke;
      context.lineWidth = strokeSize;
      context.beginPath();
      context.moveTo(x - half_size, y);
      context.lineTo(x + half_size, y);
      context.moveTo(x, y - half_size);
      context.lineTo(x, y + half_size);
      context.stroke();
    });
  }
};

export default Stencils;
