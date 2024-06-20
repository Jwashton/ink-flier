/*************************************
 * Convenience library for nicer API *
 *************************************/
export const withState = function withState(context, callback) {
  context.save();
  callback(context);
  context.restore();
};

export const fillPath = function fillPath(context, fillStyle, callback) {
  withState(context, ctx => {
    ctx.fillStyle = fillStyle;
    ctx.beginPath();
    callback(ctx);
    ctx.fill();
  });
};

export default { withState, fillPath };
