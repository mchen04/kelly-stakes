import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { useInView } from 'react-intersection-observer';
import { Check, Zap, Lock, Calculator, TrendingUp, Star } from 'lucide-react';

const Pricing = () => {
  const [ref, inView] = useInView({ threshold: 0.1, triggerOnce: true });
  const [hoveredPlan, setHoveredPlan] = useState<number | null>(null);

  const plans = [
    {
      name: 'STARTER',
      price: 0,
      period: 'Forever',
      color: 'from-gray-600 to-gray-700',
      popular: false,
      features: [
        { text: 'Full Kelly Calculator', included: true, icon: Calculator },
        { text: '1 Preset Configuration', included: true, icon: Lock },
        { text: 'All Odds Formats', included: true, icon: TrendingUp },
        { text: 'Real-time Calculations', included: true, icon: Zap },
        { text: '100% Private & Offline', included: true, icon: Lock },
        { text: 'Additional Presets', included: false },
        { text: 'Advanced Analytics', included: false },
      ],
      cta: 'Start Free',
      badge: null
    },
    {
      name: 'ADDITIONAL PRESETS',
      price: 1.99,
      period: 'per preset',
      color: 'from-green-400 to-emerald-400',
      popular: true,
      features: [
        { text: 'Everything in Starter', included: true, icon: Check },
        { text: 'Add Unlimited Presets', included: true, icon: Calculator },
        { text: 'Quick Strategy Switching', included: true, icon: Zap },
        { text: 'Multiple Risk Profiles', included: true, icon: TrendingUp },
        { text: 'Bankroll Segmentation', included: true, icon: Lock },
        { text: 'Preset Customization', included: true, icon: Check },
        { text: 'Each Preset Saved Forever', included: true, icon: Star },
      ],
      cta: 'Buy Extra Preset',
      badge: 'EXPAND YOUR TOOLKIT'
    }
  ];

  return (
    <section id="pricing" className="py-32 bg-black relative overflow-hidden">
      {/* Animated background */}
      <div className="absolute inset-0">
        <motion.div 
          className="absolute top-0 right-0 w-96 h-96 bg-green-500/10 rounded-full blur-3xl"
          animate={{ 
            scale: [1, 1.2, 1],
            opacity: [0.3, 0.5, 0.3]
          }}
          transition={{ duration: 10, repeat: Infinity }}
        />
        <motion.div 
          className="absolute bottom-0 left-0 w-96 h-96 bg-blue-500/10 rounded-full blur-3xl"
          animate={{ 
            scale: [1, 1.3, 1],
            opacity: [0.2, 0.4, 0.2]
          }}
          transition={{ duration: 15, repeat: Infinity }}
        />
      </div>

      <div className="max-w-6xl mx-auto px-4 relative z-10">
        <motion.div 
          ref={ref}
          className="text-center mb-16"
          initial={{ opacity: 0, y: 20 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.8 }}
        >
          <motion.div 
            className="inline-flex items-center gap-2 px-4 py-2 bg-green-500/10 border border-green-500/30 rounded-full mb-6"
            initial={{ scale: 0 }}
            animate={inView ? { scale: 1 } : {}}
            transition={{ delay: 0.2, type: "spring" }}
          >
            <Calculator className="w-4 h-4 text-green-400" />
            <span className="text-green-400 text-sm font-mono">PRICING PLANS</span>
          </motion.div>

          <h2 className="text-4xl sm:text-5xl font-bold text-white mb-6">
            <span className="block">Simple Pricing.</span>
            <span className="block text-transparent bg-clip-text bg-gradient-to-r from-green-400 to-emerald-400">
              Maximum Value.
            </span>
          </h2>
          
          <p className="text-xl text-gray-400 max-w-3xl mx-auto">
            Start free with full functionality. Pay only for what you need.
          </p>
        </motion.div>

        {/* Pricing Cards */}
        <div className="grid md:grid-cols-2 gap-8 max-w-4xl mx-auto">
          {plans.map((plan, index) => (
            <motion.div
              key={index}
              initial={{ opacity: 0, y: 50 }}
              animate={inView ? { opacity: 1, y: 0 } : {}}
              transition={{ delay: 0.4 + index * 0.2 }}
              onMouseEnter={() => setHoveredPlan(index)}
              onMouseLeave={() => setHoveredPlan(null)}
              className="relative"
            >
              {/* Popular badge */}
              {plan.badge && (
                <motion.div 
                  className="absolute -top-4 left-1/2 transform -translate-x-1/2 z-20"
                  initial={{ scale: 0 }}
                  animate={{ scale: 1 }}
                  transition={{ delay: 0.8, type: "spring" }}
                >
                  <div className="px-4 py-1 bg-gradient-to-r from-green-400 to-emerald-400 text-black text-xs font-bold rounded-full">
                    {plan.badge}
                  </div>
                </motion.div>
              )}

              <div className={`
                relative h-full bg-gray-900/50 backdrop-blur-sm border rounded-2xl p-8 
                transition-all duration-500 overflow-hidden
                ${plan.popular 
                  ? 'border-green-500/50 shadow-2xl shadow-green-500/20' 
                  : 'border-gray-800 hover:border-gray-700'
                }
              `}>
                {/* Animated border gradient */}
                {plan.popular && (
                  <motion.div 
                    className="absolute inset-0 opacity-50"
                    style={{
                      background: `linear-gradient(45deg, transparent 30%, rgba(74, 222, 128, 0.5) 50%, transparent 70%)`,
                      backgroundSize: '200% 200%'
                    }}
                    animate={{
                      backgroundPosition: ['0% 0%', '100% 100%', '0% 0%']
                    }}
                    transition={{ duration: 5, repeat: Infinity }}
                  />
                )}

                <div className="relative z-10">
                  {/* Header */}
                  <div className="mb-8">
                    <h3 className="text-2xl font-bold text-white mb-2">{plan.name}</h3>
                    <div className="flex items-baseline gap-2">
                      <span className={`text-5xl font-mono font-bold ${
                        plan.popular ? 'text-green-400' : 'text-white'
                      }`}>
                        ${plan.price}
                      </span>
                      <span className="text-gray-400">/{plan.period}</span>
                    </div>
                  </div>

                  {/* Features */}
                  <ul className="space-y-4 mb-8">
                    {plan.features.map((feature, i) => (
                      <motion.li 
                        key={i}
                        className="flex items-start gap-3"
                        initial={{ opacity: 0, x: -20 }}
                        animate={inView ? { opacity: 1, x: 0 } : {}}
                        transition={{ delay: 0.6 + i * 0.05 }}
                      >
                        <div className={`
                          w-5 h-5 rounded-full flex items-center justify-center flex-shrink-0 mt-0.5
                          ${feature.included 
                            ? 'bg-green-500/20' 
                            : 'bg-gray-800'
                          }
                        `}>
                          {feature.included ? (
                            <Check className="w-3 h-3 text-green-400" />
                          ) : (
                            <div className="w-2 h-0.5 bg-gray-600" />
                          )}
                        </div>
                        <span className={`text-sm ${
                          feature.included ? 'text-gray-300' : 'text-gray-600'
                        }`}>
                          {feature.text}
                        </span>
                      </motion.li>
                    ))}
                  </ul>

                  {/* CTA Button */}
                  <motion.button
                    className={`
                      w-full py-4 rounded-xl font-bold transition-all relative overflow-hidden
                      ${plan.popular 
                        ? 'bg-gradient-to-r from-green-400 to-emerald-400 text-black' 
                        : 'bg-gray-800 text-white hover:bg-gray-700'
                      }
                    `}
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                  >
                    <span className="relative z-10">{plan.cta}</span>
                    {hoveredPlan === index && (
                      <motion.div 
                        className="absolute inset-0 bg-white"
                        initial={{ x: "-100%" }}
                        animate={{ x: 0 }}
                        transition={{ duration: 0.3 }}
                      />
                    )}
                  </motion.button>
                </div>

                {/* Decorative elements */}
                {plan.popular && (
                  <>
                    <motion.div 
                      className="absolute top-4 right-4 w-20 h-20 bg-green-400/10 rounded-full blur-xl"
                      animate={{ 
                        scale: [1, 1.2, 1],
                        opacity: [0.5, 0.8, 0.5]
                      }}
                      transition={{ duration: 3, repeat: Infinity }}
                    />
                    <motion.div 
                      className="absolute bottom-4 left-4 w-32 h-32 bg-blue-400/10 rounded-full blur-xl"
                      animate={{ 
                        scale: [1, 1.3, 1],
                        opacity: [0.3, 0.6, 0.3]
                      }}
                      transition={{ duration: 4, repeat: Infinity }}
                    />
                  </>
                )}
              </div>
            </motion.div>
          ))}
        </div>

        {/* Trust indicators */}
        <motion.div 
          className="mt-16 text-center"
          initial={{ opacity: 0 }}
          animate={inView ? { opacity: 1 } : {}}
          transition={{ delay: 1 }}
        >
          <div className="inline-flex items-center gap-8 px-8 py-4 bg-gray-900/50 backdrop-blur-sm border border-gray-800 rounded-2xl">
            <div className="flex items-center gap-2">
              <Lock className="w-4 h-4 text-green-400" />
              <span className="text-sm text-gray-400">Secure Payment</span>
            </div>
            <div className="h-6 w-px bg-gray-700" />
            <div className="flex items-center gap-2">
              <Zap className="w-4 h-4 text-green-400" />
              <span className="text-sm text-gray-400">Instant Activation</span>
            </div>
            <div className="h-6 w-px bg-gray-700" />
            <div className="flex items-center gap-2">
              <Star className="w-4 h-4 text-green-400" />
              <span className="text-sm text-gray-400">StoreKit 2 Integration</span>
            </div>
          </div>
        </motion.div>
      </div>
    </section>
  );
};

export default Pricing;