import React from 'react';
import { motion } from 'framer-motion';
import { useInView } from 'react-intersection-observer';
import { 
  Calculator, 
  BookOpen, 
  Globe, 
  Lock,
  LineChart,
  Cpu,
  Zap,
  Shield
} from 'lucide-react';

const Features = () => {
  const [ref, inView] = useInView({ threshold: 0.1, triggerOnce: true });

  const features = [
    {
      icon: Calculator,
      title: 'Real-Time Kelly Calculator',
      description: 'Sub-200ms calculations with visual validation and precision display.',
      metric: '< 200ms',
      color: 'from-green-400 to-emerald-400',
      glow: 'green'
    },
    {
      icon: Cpu,
      title: 'Preset Management',
      description: 'Save multiple betting scenarios with custom bankrolls and Kelly multipliers.',
      metric: '$1.99/preset',
      color: 'from-blue-400 to-cyan-400',
      glow: 'blue'
    },
    {
      icon: LineChart,
      title: 'Dual Odds Support',
      description: 'American (+150/-200) and Decimal (2.50) odds formats with smart conversion.',
      metric: '2 Formats',
      color: 'from-purple-400 to-pink-400',
      glow: 'purple'
    },
    {
      icon: Shield,
      title: '100% Private & Local',
      description: 'No data collection, no cloud sync. All calculations on your device.',
      metric: '100% Local',
      color: 'from-orange-400 to-red-400',
      glow: 'orange'
    }
  ];

  const containerVariants = {
    hidden: { opacity: 0 },
    visible: {
      opacity: 1,
      transition: {
        staggerChildren: 0.1
      }
    }
  };

  const itemVariants = {
    hidden: { y: 50, opacity: 0 },
    visible: {
      y: 0,
      opacity: 1,
      transition: {
        type: "spring",
        stiffness: 100
      }
    }
  };

  return (
    <section id="features" className="py-32 bg-black relative overflow-hidden">
      {/* Animated background grid */}
      <div className="absolute inset-0 opacity-10">
        <div className="absolute inset-0" style={{
          backgroundImage: `linear-gradient(rgba(0, 255, 0, 0.1) 1px, transparent 1px),
                           linear-gradient(90deg, rgba(0, 255, 0, 0.1) 1px, transparent 1px)`,
          backgroundSize: '100px 100px'
        }} />
      </div>

      {/* Floating orbs */}
      <motion.div 
        className="absolute top-20 left-10 w-64 h-64 bg-green-500/10 rounded-full blur-3xl"
        animate={{ 
          x: [0, 100, 0],
          y: [0, -50, 0],
        }}
        transition={{ duration: 20, repeat: Infinity }}
      />
      <motion.div 
        className="absolute bottom-20 right-10 w-96 h-96 bg-blue-500/10 rounded-full blur-3xl"
        animate={{ 
          x: [0, -100, 0],
          y: [0, 50, 0],
        }}
        transition={{ duration: 25, repeat: Infinity }}
      />

      <div className="max-w-7xl mx-auto px-4 relative z-10">
        <motion.div 
          className="text-center mb-20"
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
            <Zap className="w-4 h-4 text-green-400" />
            <span className="text-green-400 text-sm font-mono">CORE FEATURES</span>
          </motion.div>

          <h2 className="text-4xl sm:text-5xl font-bold text-white mb-6">
            <span className="block">Professional Tools.</span>
            <span className="block text-transparent bg-clip-text bg-gradient-to-r from-green-400 to-emerald-400">
              Bettor's Edge.
            </span>
          </h2>
          
          <p className="text-xl text-gray-400 max-w-3xl mx-auto">
            Built for serious sports bettors who demand precision. Every feature engineered for optimal bankroll management.
          </p>
        </motion.div>

        <motion.div 
          ref={ref}
          className="grid md:grid-cols-2 lg:grid-cols-4 gap-6"
          variants={containerVariants}
          initial="hidden"
          animate={inView ? "visible" : "hidden"}
        >
          {features.map((feature, index) => (
            <motion.div
              key={index}
              variants={itemVariants}
              className="group relative"
            >
              <div className="relative bg-gray-900/50 backdrop-blur-sm border border-gray-800 rounded-2xl p-8 h-full overflow-hidden transition-all duration-500 hover:border-gray-700">
                {/* Glow effect on hover */}
                <div className={`absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity duration-500`}>
                  <div className={`absolute inset-0 bg-gradient-to-br ${feature.color} opacity-5`} />
                </div>

                {/* Metric badge */}
                <div className="absolute top-4 right-4">
                  <div className={`px-3 py-1 bg-gradient-to-r ${feature.color} rounded-full opacity-20`}>
                    <span className="text-xs font-mono text-white font-bold opacity-100">{feature.metric}</span>
                  </div>
                </div>

                {/* Icon with animation */}
                <motion.div 
                  className={`w-16 h-16 rounded-2xl bg-gradient-to-br ${feature.color} p-0.5 mb-6`}
                  whileHover={{ rotate: 360, scale: 1.1 }}
                  transition={{ duration: 0.5 }}
                >
                  <div className="w-full h-full bg-gray-900 rounded-2xl flex items-center justify-center">
                    <feature.icon className="w-8 h-8 text-white" />
                  </div>
                </motion.div>

                <h3 className="text-xl font-bold text-white mb-3">{feature.title}</h3>
                <p className="text-gray-400 leading-relaxed">{feature.description}</p>

                {/* Interactive element */}
                <div className="mt-6 pt-6 border-t border-gray-800">
                  <div className="flex items-center justify-between">
                    <div className="flex -space-x-2">
                      {[1, 2, 3].map((i) => (
                        <div 
                          key={i} 
                          className={`w-2 h-2 rounded-full bg-gradient-to-r ${feature.color} opacity-${10 - i * 2}0`}
                        />
                      ))}
                    </div>
                    <motion.div
                      className="text-gray-600 group-hover:text-green-400 transition-colors"
                      initial={{ x: 0 }}
                      whileHover={{ x: 5 }}
                    >
                      →
                    </motion.div>
                  </div>
                </div>

                {/* Animated corner accent */}
                <motion.div
                  className="absolute bottom-0 right-0 w-32 h-32 opacity-10"
                  initial={{ scale: 0, opacity: 0 }}
                  whileHover={{ scale: 1, opacity: 0.2 }}
                  transition={{ duration: 0.3 }}
                >
                  <svg viewBox="0 0 100 100" className="w-full h-full">
                    <circle 
                      cx="100" 
                      cy="100" 
                      r="80" 
                      fill="none" 
                      stroke="url(#gradient)" 
                      strokeWidth="0.5"
                    />
                    <defs>
                      <linearGradient id="gradient">
                        <stop offset="0%" stopColor="rgb(74, 222, 128)" />
                        <stop offset="100%" stopColor="rgb(52, 211, 153)" />
                      </linearGradient>
                    </defs>
                  </svg>
                </motion.div>
              </div>
            </motion.div>
          ))}
        </motion.div>

        {/* Bottom CTA section */}
        <motion.div 
          className="mt-20 text-center"
          initial={{ opacity: 0 }}
          animate={inView ? { opacity: 1 } : {}}
          transition={{ delay: 0.8 }}
        >
          <div className="inline-flex items-center gap-4 px-6 py-3 bg-gray-900/50 backdrop-blur-sm border border-gray-800 rounded-full">
            <div className="flex items-center gap-2">
              <div className="w-2 h-2 rounded-full bg-green-400 animate-pulse" />
              <span className="text-sm text-gray-400">Live now</span>
            </div>
            <div className="h-4 w-px bg-gray-700" />
            <span className="text-sm font-mono text-green-400">v2.0.1</span>
            <div className="h-4 w-px bg-gray-700" />
            <span className="text-sm text-gray-400">Premium iOS App</span>
          </div>
        </motion.div>
      </div>
    </section>
  );
};

export default Features;