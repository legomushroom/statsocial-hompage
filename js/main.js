// Generated by CoffeeScript 1.6.2
(function() {
  var App;

  App = (function() {
    function App() {
      this.vars();
      this.initScroll();
      this.initController();
      this.buildAnimations();
      this.initParallax();
    }

    App.prototype.vars = function() {
      this.$main = $('#js-main');
      this.$body = $(document.body);
      this.scrollPos = 0;
      this.$window = $(window);
      this.$window.height();
      this.frameDurationTime = 5000;
      this.$mainLogo = this.$('#js-main-logo');
      this.$script1 = this.$('#js-script1');
      this.$script2 = this.$('#js-script2');
      this.$scence = this.$('#js-curtain1');
      this.$scence2 = this.$('#js-curtain2');
      this.$scence3 = this.$('#js-curtain3');
      this.$plane = this.$('#js-plane');
      return this.prevPlaneProgress = -1;
    };

    App.prototype.initController = function() {
      return this.controller = $.superscrollorama({
        triggerAtCenter: false,
        playoutAnimations: true
      });
    };

    App.prototype.initScroll = function() {
      var it;

      this.scroller = new IScroll('#js-main', {
        probeType: 3,
        mouseWheel: true
      });
      document.addEventListener('touchmove', (function(e) {
        return e.preventDefault();
      }), false);
      it = this;
      this.scroller.on('scroll', function() {
        return it.updateScrollPos(this, it);
      });
      return this.scroller.on('scrollEnd', function() {
        return it.updateScrollPos(this, it);
      });
    };

    App.prototype.initParallax = function() {
      this.$scence.parallax();
      return this.$scence2.parallax();
    };

    App.prototype.updateScrollPos = function(that, it) {
      return it.controller.setScrollContainerOffset(0, -(that.y >> 0)).triggerCheckAnim(true);
    };

    App.prototype.buildAnimations = function() {
      var $buildings, $clouds, $el, $images, $leftEls, $rightEls, el, i, rotateDegree, rotateElsCountLeft, start, _i, _j, _k, _l, _len, _len1, _ref, _ref1, _ref2,
        _this = this;

      this.curtainTween1 = TweenMax.to(this.$('.curtain-l'), .75, {
        css: {
          top: '-100%'
        },
        onUpdate: StatSocial.helpers.bind(this.onCurtain1Update, this)
      });
      this.curtainTween2 = TweenMax.to(this.$('.curtain2-l'), .75, {
        css: {
          top: '-22px',
          y: 0
        }
      });
      this.scriptTween1 = TweenMax.to(this.$script1, .75, {
        css: {
          top: '50%',
          opacity: 1
        }
      });
      this.scriptTween12 = TweenMax.to(this.$script1, .75, {
        css: {
          top: '95%'
        }
      });
      this.logoTween = TweenMax.to(this.$mainLogo, .75, {
        css: {
          top: '100%'
        }
      });
      this.$mainLogo.css({
        'top': '50%'
      });
      this.controller.addTween(1, this.scriptTween1, this.frameDurationTime);
      start = this.frameDurationTime;
      this.controller.addTween(start, this.curtainTween1, this.frameDurationTime);
      this.controller.addTween(start, this.curtainTween2, this.frameDurationTime);
      this.controller.addTween(start, this.scriptTween12, this.frameDurationTime / 2);
      this.controller.addTween(start, this.logoTween, this.frameDurationTime / 2);
      this.scriptTween2 = TweenMax.to(this.$script2, .75, {
        css: {
          top: '50%'
        }
      });
      this.controller.addTween(this.frameDurationTime, this.scriptTween2, this.frameDurationTime * 1.5);
      $images = this.$scence.find('.curtain-layer-lh');
      for (i = _i = 0, _len = $images.length; _i < _len; i = ++_i) {
        el = $images[i];
        $el = $(el);
        this.controller.addTween(this.frameDurationTime, TweenMax.to($el, .75, {
          css: {
            top: "" + (50 + (i * 5)) + "%"
          }
        }), this.frameDurationTime);
      }
      this.$left = this.$('#js-curtain2-left-side');
      this.$right = this.$('#js-curtain2-right-side');
      $leftEls = this.$left.find('.curtain2-section-lh');
      $rightEls = this.$right.find('.curtain2-section-lh');
      start = 3 * this.frameDurationTime;
      rotateDegree = 5;
      rotateElsCountLeft = Math.min($leftEls.length, 10);
      for (i = _j = _ref = $leftEls.length, _ref1 = $leftEls.length - rotateElsCountLeft; _ref <= _ref1 ? _j <= _ref1 : _j >= _ref1; i = _ref <= _ref1 ? ++_j : --_j) {
        $el = $($leftEls.eq(i));
        this.controller.addTween(start - (i * (this.frameDurationTime / $leftEls.length)), TweenMax.to($el, .75, {
          css: {
            rotation: rotateDegree,
            transformOrigin: 'left top'
          }
        }), this.frameDurationTime);
      }
      for (i = _k = 0, _len1 = $rightEls.length; _k < _len1; i = ++_k) {
        el = $rightEls[i];
        $el = $(el);
        this.controller.addTween(start - (($rightEls.length - i) * (this.frameDurationTime / $rightEls.length)), TweenMax.to($el, .75, {
          css: {
            rotation: -rotateDegree,
            transformOrigin: 'right top'
          }
        }), this.frameDurationTime);
      }
      start = 2.5 * this.frameDurationTime;
      this.curtain2LeftTween = TweenMax.to(this.$left, .75, {
        css: {
          left: -this.$window.outerWidth() / 2
        },
        onUpdate: StatSocial.helpers.bind(this.onCurtain2Update, this)
      });
      this.controller.addTween(start, this.curtain2LeftTween, this.frameDurationTime);
      this.controller.addTween(start, TweenMax.to(this.$right, .75, {
        css: {
          left: (this.$window.outerWidth() / 2) + $rightEls.first().outerWidth()
        }
      }), this.frameDurationTime);
      start = 4.5 * this.frameDurationTime;
      this.groundTween = TweenMax.to(this.$('#js-ground'), .75, {
        css: {
          x: 0
        }
      });
      this.controller.addTween(start, this.groundTween, this.frameDurationTime);
      this.bgTween = TweenMax.to(this.$('#js-bg'), .75, {
        css: {
          opacity: 1
        }
      });
      this.controller.addTween(start, this.bgTween, this.frameDurationTime);
      $clouds = this.$('.cloud-b');
      this.cloudTween = TweenMax.to($clouds, .75, {
        onComplete: (function() {
          return $clouds.addClass('is-anima');
        }),
        onReverseComplete: (function() {
          return $clouds.removeClass('is-anima');
        })
      });
      this.controller.addTween(start, this.cloudTween, 1);
      start = 7 * this.frameDurationTime;
      $buildings = this.$('.building-b');
      for (i = _l = 0, _ref2 = $buildings.length; 0 <= _ref2 ? _l <= _ref2 : _l >= _ref2; i = 0 <= _ref2 ? ++_l : --_l) {
        $el = $($buildings.eq(i));
        this.controller.addTween(start - (($buildings.length - i) * (this.frameDurationTime / $buildings.length)), TweenMax.to($el, .75, {
          css: {
            y: 0,
            bottom: 145
          }
        }), this.frameDurationTime);
      }
      this.scriptTween3 = TweenMax.to(this.$script2, .75, {
        css: {
          top: '-10%'
        },
        onUpdate: StatSocial.helpers.bind(this.onCurtain2UpdateEnd, this)
      });
      this.controller.addTween(start - (this.frameDurationTime / 10), this.scriptTween3, this.frameDurationTime * 1.5);
      start = 8 * this.frameDurationTime;
      this.$plane = this.$('#js-plane');
      this.$planeInner = this.$plane.find('#js-plane-inner');
      this.planeTween = TweenMax.to(this.$plane, .75, {
        css: {
          left: '-100%'
        },
        onUpdate: StatSocial.helpers.bind(this.onPlaneUpdate, this)
      });
      this.controller.addTween(start, this.planeTween, this.frameDurationTime * 6);
      start = 10 * this.frameDurationTime;
      this.bushTween = TweenMax.to($clouds, .75, {
        onComplete: (function() {
          return _this.$scence3.addClass('is-show-bushes');
        }),
        onReverseComplete: (function() {
          return _this.$scence3.removeClass('is-show-bushes');
        })
      });
      this.controller.addTween(start, this.bushTween, 1);
      start = 12 * this.frameDurationTime;
      this.$yAxes = this.$('#js-roller-y');
      this.$xAxes = this.$('#js-roller-x');
      this.$rollerLine1 = this.$('#js-roller-line1');
      this.$rollerLine2 = this.$('#js-roller-line2');
      this.rollerLine1 = this.$rollerLine1[0];
      this.rollerLine2 = this.$rollerLine2[0];
      this.$rollerLineBg2 = this.$('#js-roller-line-bg2');
      this.$rollerLineBg1 = this.$('#js-roller-line-bg1');
      this.$rollerCabin1 = this.$('#js-roller-cabin1');
      this.$rollerCabinParent1 = this.$rollerCabin1.parent();
      this.$rollerCabin2 = this.$('#js-roller-cabin2');
      this.$rollerCabinParent2 = this.$rollerCabin2.parent();
      this.$rollerCabin3 = this.$('#js-roller-cabin3');
      this.$rollerCabinParent3 = this.$rollerCabin3.parent();
      this.$rollerCabin4 = this.$('#js-roller-cabin4');
      this.$rollerCabinParent4 = this.$rollerCabin4.parent();
      this.$rollerCabin5 = this.$('#js-roller-cabin5');
      this.$rollerCabinParent5 = this.$rollerCabin5.parent();
      this.$rollerCabin6 = this.$('#js-roller-cabin6');
      this.$rollerCabinParent6 = this.$rollerCabin6.parent();
      this.$rollerCabin7 = this.$('#js-roller-cabin7');
      this.$rollerCabinParent7 = this.$rollerCabin7.parent();
      this.$rollerText = this.$('#js-roller-text');
      this.rollerLine2Length = this.rollerLine2.getTotalLength();
      this.rollerText = this.$rollerText[0];
      this.rollerTextOffset = parseInt(this.rollerText.getAttribute('startOffset'), 10);
      this.rollerAxesTween = TweenMax.to({}, .75, {
        onUpdate: StatSocial.helpers.bind(this.onRollerAxesUpdate, this)
      });
      this.controller.addTween(start, this.rollerAxesTween, this.frameDurationTime);
      start = 13 * this.frameDurationTime;
      this.rollerRailsTween1 = TweenMax.to({
        y: 400
      }, .75, {
        y: 0,
        onUpdate: StatSocial.helpers.bind(this.onRollerRails1Update, this)
      });
      this.controller.addTween(start, this.rollerRailsTween1, this.frameDurationTime);
      this.rollerRailsTween2 = TweenMax.to({
        y: 400
      }, 1, {
        y: 0,
        onUpdate: StatSocial.helpers.bind(this.onRollerRails2Update, this)
      });
      this.controller.addTween(start, this.rollerRailsTween2, 2 * this.frameDurationTime);
      start = 15 * this.frameDurationTime;
      this.rollerTextTween = TweenMax.to({
        offset: this.rollerTextOffset
      }, 1, {
        offset: this.rollerLine2.getTotalLength(),
        onUpdate: StatSocial.helpers.bind(this.onRollerTextUpdate, this)
      });
      this.controller.addTween(start, this.rollerTextTween, 4 * this.frameDurationTime);
      start = 19 * this.frameDurationTime;
      this.rollerCabinsTriggerTween = TweenMax.to({}, 1, {
        onComplete: (function() {
          _this.initRollerCabins();
          return _this.showSecondTrain();
        }),
        onReverseComplete: (function() {
          var _ref3;

          if ((_ref3 = _this.rollerCabinsTween) != null) {
            _ref3.pause();
          }
          _this.rollerCabinsTween2.pause();
          return _this.hideSecondTrain();
        })
      });
      return this.controller.addTween(start, this.rollerCabinsTriggerTween, 1);
    };

    App.prototype.initRollerCabins = function() {
      if (!this.rollerCabinsTween) {
        this.rollerCabinsTween = TweenMax.to({
          p: -110
        }, 6, {
          p: this.rollerLine2Length,
          repeatDelay: 3,
          repeat: -1,
          onUpdate: StatSocial.helpers.bind(this.onRollerCabinsUpdate, this)
        });
      } else {
        this.rollerCabinsTween.resume();
      }
      if (!this.rollerCabinsTween2) {
        return this.rollerCabinsTween2 = TweenMax.to({
          p: -110
        }, 6, {
          p: this.rollerLine2Length,
          delay: 2,
          repeatDelay: 3,
          repeat: -1,
          onUpdate: StatSocial.helpers.bind(this.onRollerCabinsUpdate2, this)
        });
      } else {
        return this.rollerCabinsTween2.resume();
      }
    };

    App.prototype.onRollerCabinsUpdate2 = function() {
      var info1, info2, info3, info4, pathProgress;

      pathProgress = this.rollerCabinsTween2.target.p;
      info1 = this.getRollerPathInfo(pathProgress + 10, true);
      info2 = this.getRollerPathInfo(pathProgress + 50, true);
      info3 = this.getRollerPathInfo(pathProgress + 90, true);
      info4 = this.getRollerPathInfo(pathProgress + 130, true);
      this.$rollerCabinParent4.attr('transform', "translate(" + (info1.point.x - 22) + ", " + (info1.point.y - 25) + ") rotate(" + (info1.degree || 0) + ", 22, 21)");
      this.$rollerCabinParent5.attr('transform', "translate(" + (info2.point.x - 22) + ", " + (info2.point.y - 25) + ") rotate(" + (info2.degree || 0) + ", 22, 21)");
      this.$rollerCabinParent6.attr('transform', "translate(" + (info3.point.x - 22) + ", " + (info3.point.y - 25) + ") rotate(" + (info3.degree || 0) + ", 22, 21)");
      return this.$rollerCabinParent7.attr('transform', "translate(" + (info4.point.x - 22) + ", " + (info4.point.y - 25) + ") rotate(" + (info4.degree || 0) + ", 22, 21)");
    };

    App.prototype.onRollerCabinsUpdate = function() {
      var info1, info2, info3, pathProgress;

      pathProgress = this.rollerCabinsTween.target.p;
      info1 = this.getRollerPathInfo(pathProgress + 10);
      info2 = this.getRollerPathInfo(pathProgress + 50);
      info3 = this.getRollerPathInfo(pathProgress + 90);
      this.$rollerCabinParent1.attr('transform', "translate(" + (info1.point.x - 22) + ", " + (info1.point.y - 25) + ") rotate(" + (info1.degree || 0) + ", 22, 21)");
      this.$rollerCabinParent2.attr('transform', "translate(" + (info2.point.x - 22) + ", " + (info2.point.y - 25) + ") rotate(" + (info2.degree || 0) + ", 22, 21)");
      return this.$rollerCabinParent3.attr('transform', "translate(" + (info3.point.x - 22) + ", " + (info3.point.y - 25) + ") rotate(" + (info3.degree || 0) + ", 22, 21)");
    };

    App.prototype.hideSecondTrain = function() {
      if (!this.isSecondTrainHide) {
        this.$rollerCabinParent4.fadeOut();
        this.$rollerCabinParent5.fadeOut();
        this.$rollerCabinParent6.fadeOut();
        this.$rollerCabinParent7.fadeOut();
        return this.isSecondTrainHide = true;
      }
    };

    App.prototype.showSecondTrain = function() {
      if (this.isSecondTrainHide) {
        this.$rollerCabinParent4.fadeIn();
        this.$rollerCabinParent5.fadeIn();
        this.$rollerCabinParent6.fadeIn();
        this.$rollerCabinParent7.fadeIn();
        return this.isSecondTrainHide = false;
      }
    };

    App.prototype.onRollerTextUpdate = function() {
      var info1, info2, info3, pathProgress;

      pathProgress = this.rollerTextTween.target.offset - this.rollerTextOffset;
      info1 = this.getRollerPathInfo(pathProgress + 10);
      info2 = this.getRollerPathInfo(pathProgress + 50);
      info3 = this.getRollerPathInfo(pathProgress + 90);
      this.rollerText.setAttribute('startOffset', "" + this.rollerTextTween.target.offset);
      this.$rollerCabinParent1.attr('transform', "translate(" + (info1.point.x - 22) + ", " + (info1.point.y - 25) + ") rotate(" + (info1.degree || 0) + ", 22, 21)");
      this.$rollerCabinParent2.attr('transform', "translate(" + (info2.point.x - 22) + ", " + (info2.point.y - 25) + ") rotate(" + (info2.degree || 0) + ", 22, 21)");
      return this.$rollerCabinParent3.attr('transform', "translate(" + (info3.point.x - 22) + ", " + (info3.point.y - 25) + ") rotate(" + (info3.degree || 0) + ", 22, 21)");
    };

    App.prototype.getRollerPathInfo = function(progress, isSecondLine) {
      var cathetus, degree, hypotenuse, line, point, prevPoint, returnObj;

      line = !isSecondLine ? this.rollerLine2 : this.rollerLine1;
      point = line.getPointAtLength(progress);
      prevPoint = line.getPointAtLength(progress - 2);
      cathetus = point.x - prevPoint.x;
      hypotenuse = Math.sqrt(Math.pow(point.x - prevPoint.x, 2) + Math.pow(point.y - prevPoint.y, 2));
      degree = Math.acos(cathetus / hypotenuse) * (180 / Math.PI);
      if ((point.y - prevPoint.y) < 0) {
        degree = -degree;
      }
      return returnObj = {
        degree: degree,
        point: point
      };
    };

    App.prototype.onRollerRails1Update = function() {
      this.$rollerLine1.attr('transform', "translate(0," + this.rollerRailsTween1.target.y + ")");
      return this.$rollerLineBg1.attr('transform', "translate(0," + this.rollerRailsTween1.target.y + ")");
    };

    App.prototype.onRollerRails2Update = function() {
      this.$rollerLine2.attr('transform', "translate(0," + this.rollerRailsTween2.target.y + ")");
      return this.$rollerLineBg2.attr('transform', "translate(0," + this.rollerRailsTween2.target.y + ")");
    };

    App.prototype.onRollerAxesUpdate = function() {
      var progress;

      progress = this.rollerAxesTween.totalProgress();
      this.$yAxes.attr('transform', "translate(0," + (520 - (520 * progress)) + ")");
      return this.$xAxes.attr('transform', "translate(" + (-1240 + (1240 * progress)) + ",0)");
    };

    App.prototype.onPlaneUpdate = function() {
      var progress;

      progress = this.planeTween.totalProgress();
      if (this.prevPlaneProgress > progress) {
        !this.isPlaneFlip && this.$planeInner.addClass('is-flip');
        this.isPlaneFlip = true;
      } else {
        this.isPlaneFlip && this.$planeInner.removeClass('is-flip');
        this.isPlaneFlip = false;
      }
      this.prevPlaneProgress = progress;
      if (progress > .2 && progress < 1) {
        !this.isBuildingCategories && this.$scence3.addClass('show-building-categories-gt');
        this.isBuildingCategories = true;
      } else {
        this.isBuildingCategories && this.$scence3.removeClass('show-building-categories-gt');
        this.isBuildingCategories = false;
      }
      if (progress >= 1) {
        !this.isPlaneHide && this.$plane.hide();
        return this.isPlaneHide = true;
      } else {
        this.isPlaneHide && this.$plane.show();
        return this.isPlaneHide = false;
      }
    };

    App.prototype.$ = function(selector) {
      return this.$main.find(selector);
    };

    App.prototype.onCurtain1Update = function() {
      if (this.curtainTween1.totalProgress() >= 1) {
        this.isFirstCurtainParallax && this.$scence.parallax('disable');
        this.isFirstCurtainParallax = false;
        return this.$scence.hide();
      } else {
        !this.isFirstCurtainParallax && this.$scence.parallax('enable');
        this.isFirstCurtainParallax = true;
        return this.$scence.show();
      }
    };

    App.prototype.onCurtain2Update = function() {
      if (this.curtain2LeftTween.totalProgress() >= 1) {
        this.isSecondCurtainParallax && this.$scence2.parallax('disable');
        this.isSecondCurtainParallax = false;
        this.$left.hide();
        return this.$right.hide();
      } else {
        !this.isSecondCurtainParallax && this.$scence2.parallax('enable');
        this.isSecondCurtainParallax = true;
        this.$left.show();
        return this.$right.show();
      }
    };

    App.prototype.onCurtain2UpdateEnd = function() {
      if (this.scriptTween3.totalProgress() >= 1) {
        return this.$scence2.hide();
      } else {
        return this.$scence2.show();
      }
    };

    return App;

  })();

  new App;

}).call(this);

/*
//@ sourceMappingURL=main.map
*/
