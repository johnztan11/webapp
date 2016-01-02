/*
 * Copyright (C) 2013 Panopta, Andrew Moffat
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
(function ($) {

    
    var WizardCard = function(wizard, card, index, prev, next) {
        this.wizard 	= wizard;
        this.index 		= index;
        this.prev 		= prev;
        this.next 		= next;
        this.el 		= card;
        this.title 		= card.find("h3").first().text();
        this.name 		= card.data("cardname") || this.title;

        this.nav 		= this._createNavElement(this.title, index);

        this._disabled 	= false;
        this._loaded 	= false;
        this._events =	 {};
    };
    
    WizardCard.prototype = {
        select: function() {
            this.log("selecting");
            if (!this.isSelected()) {
                this.nav.addClass("active");
                this.el.show();

                if (!this._loaded) {
                    this.trigger("loaded");
                    this.reload();
                }

                this.trigger("selected");
            }


            /*
             * this is ugly, but we're handling the changing of the wizard's
             * buttons here, in the WizardCard select.  so when a card is
             * selected, we're figuring out if we're the first card or the
             * last card and changing the wizard's buttons via the guts of
             * the wizard
             *
             * ideally this logic should be encapsulated by some wizard methods
             * that we can call from here, instead of messing with the guts
             */
            var w = this.wizard;

            // The back button is only disabled on this first card...
            w.backButton.toggleClass("disabled", this.index == 0);

            if (this.index >= w._cards.length-1) {
                this.log("on last card, changing next button to submit");

                w.changeNextButton(w.args.buttons.submitText, "btn-success");
                w._readyToSubmit = true;
                w.trigger("readySubmit");
            }
            else {
                w._readyToSubmit = false;
                w.changeNextButton(w.args.buttons.nextText, "btn-primary");
            }

            return this;
        },

        _createNavElement: function(name, i) {
            var li = $('<li class="wizard-nav-item"></li>');
            var a = $('<a class="wizard-nav-link"></a>');
            a.data("navindex", i);
            li.append(a);
            a.append('<span class="glyphicon glyphicon-chevron-right"></span> ');
            a.append(name);
            return li;
        },

        markVisited: function() {
            this.log("marking as visited");
            this.nav.addClass("already-visited");
            this.trigger("markVisited");
            return this;
        },

        unmarkVisited: function() {
            this.log("unmarking as visited");
            this.nav.removeClass("already-visited");
            this.trigger("unmarkVisited");
            return this;
        },

        deselect: function() {
            this.nav.removeClass("active");
            this.el.hide();
            this.trigger("deselect");
            return this;
        },

        enable: function() {
            this.log("enabling");
            
            // Issue #38 Hiding navigation link when hide card
            // Awaiting approval
            //
            // this.nav.removeClass('hide');
            
            this.nav.addClass("active");
            this._disabled = false;
            this.trigger("enabled");
            return this;
        },

        disable: function(hideCard) {
            this.log("disabling");
            this._disabled = true;
            this.nav.removeClass("active already-visited");
            if (hideCard) {
                this.el.hide();
                // Issue #38 Hiding navigation link when hide card
                // Awaiting approval
                //
                // this.nav.addClass('hide');
            }
            this.trigger("disabled");
            return this;
        },

        isDisabled: function() {
            return this._disabled;
        },

        alreadyVisited: function() {
            return this.nav.hasClass("already-visited");
        },

        isSelected: function() {
            return this.nav.hasClass("active");
        },

        reload: function() {
            this._loaded = true;
            this.trigger("reload");
            return this;
        },

        on: function() {
            return this.wizard.on.apply(this, arguments);
        },

        trigger: function() {
            this.callListener("on"+arguments[0]);
            return this.wizard.trigger.apply(this, arguments);
        },

        /*
         * displays an alert box on the current card
         */
        toggleAlert: function(msg, toggle) {
            this.log("toggling alert to: " + toggle);

            toggle = typeof(toggle) == "undefined" ? true : toggle;

            if (toggle) {this.trigger("showAlert");}
            else {this.trigger("hideAlert");}

            var div;
            var alert = this.el.children("h3").first().next("div.alert");

            if (alert.length == 0) {
                /*
                 * we're hiding anyways, so no need to create anything.
                 * we'll do that if we ever are actually showing the alert
                 */
                if (!toggle) {return this;}

                this.log("couldn't find existing alert div, creating one");
                div = $("<div />");
                div.addClass("alert");
                div.addClass("hide");
                div.insertAfter(this.el.find("h3").first());
            }
            else {
                this.log("found existing alert div");
                div = alert.first();
            }

            if (toggle) {
                if (msg != null) {
                    this.log("setting alert msg to", msg);
                    div.html(msg);
                }
                div.show();
            }
            else {
                div.hide();
            }
            return this;
        },

        /*
         * this looks for event handlers embedded into the html of the
         * wizard card itself, in the form of a data- attribute
         */
        callListener: function(name) {
            // a bug(?) in jquery..can't access data-<name> if name is camelCase
            name = name.toLowerCase();

            this.log("looking for listener " + name);
            var listener = window[this.el.data(name)];
            if (listener) {
                this.log("calling listener " + name);
                var wizard = this.wizard;

                try {
                    var vret = listener(this);
                }
                catch (e) {
                    this.log("exception calling listener " + name + ": ", e);
                }
            }
            else {
                this.log("didn't find listener " + name);
            }
        },

        problem: function(toggle) {
            this.nav.find("a").toggleClass("wizard-step-error", toggle);
        },

        validate: function() {
            var failures = false;
            var self = this;

            /*
             * run all the validators embedded on the inputs themselves
             */
            this.el.find("[data-validate]").each(function(i, el) {
                self.log("validating individiual inputs");
                el = $(el);

                var v = el.data("validate");
                if (!v) {return;}

                var ret = {
                    status: true,
                    title: "Error",
                    msg: ""
                };

                var vret = window[v](el);
                $.extend(ret, vret);

                // Add-On
                // This allows the use of a INPUT+BTN used as one according to boostrap layout
                // for the wizard it is required to add an id with btn-(ID of Input)
                // this will make sure the popover is drawn on the correct element
                if ( $('#btn-' + el.attr('id')).length === 1 ) {
                    el = $('#btn-' + el.attr('id'));
                }

                if (!ret.status) {
                    failures = true;
                    
                    // Updated to show error on correct form-group
                    el.parents("div.form-group").toggleClass("has-error", true);
                    
                    // This allows the use of a INPUT+BTN used as one according to boostrap layout
                    // for the wizard it is required to add an id with btn-(ID of Input)
                    // this will make sure the popover is drawn on the correct element
                    if ( $('#btn-' + el.attr('id')).length === 1 ) {
                        el = $('#btn-' + el.attr('id'));
                    }
                    
                    self.wizard.errorPopover(el, ret.msg);
                } else {
                    el.parents("div.form-group").toggleClass("has-error", false);
                    
                    // This allows the use of a INPUT+BTN used as one according to boostrap layout
                    // for the wizard it is required to add an id with btn-(ID of Input)
                    // this will make sure the popover is drawn on the correct element
                    if ( $('#btn-' + el.attr('id')).length === 1 ) {
                        el = $('#btn-' + el.attr('id'));
                    }
                    
                    try {
                        el.popover("destroy");
                    }
                    /*
                     * older versions of bootstrap don't have a destroy call
                     * for popovers
                     */
                    catch (e) {
                        el.popover("hide");
                    }
                }
            });
            this.log("after validating inputs, failures is", failures);

            /*
             * run the validator embedded in the card
             */
            var cardValidator = window[this.el.data("validate")];
            if (cardValidator) {
                this.log("running html-embedded card validator");
                var cardValidated = cardValidator(this);
                if (typeof(cardValidated) == "undefined" || cardValidated == null) {
                    cardValidated = true;
                }
                if (!cardValidated) failures = true;
                this.log("after running html-embedded card validator, failures is", failures);
            }

            /*
             * run the validate listener
             */
            this.log("running listener validator");
            var listenerValidated = this.trigger("validate");
            if (typeof(listenerValidated) == "undefined" || listenerValidated == null) {
                listenerValidated = true;
            }
            if (!listenerValidated) failures = true;
            this.log("after running listener validator, failures is", failures);

            var validated = !failures;
            if (validated) {
                this.log("validated, calling listeners");
                this.trigger("validated");
            }
            else {
                this.log("invalid");
                this.trigger("invalid");
            }
            return validated;
        },
        
        log: function() {
            if (!window.console || !$.fn.wizard.logging) {return;}
            var prepend = "card '"+this.name+"': ";
            var args = [prepend];
            args.push.apply(args, arguments);

            console.log.apply(console, args);
        },

        isActive: function() {
            return this.nav.hasClass("active");
        }
    };
    
    
    
}(window.jQuery));
