import React from 'react';
import { motion } from 'framer-motion';
import { useInView } from 'react-intersection-observer';
import { AlertTriangle, Calculator, TrendingUp, Info } from 'lucide-react';

const KellyExplainer = () => {
  const [ref, inView] = useInView({ threshold: 0.1, triggerOnce: true });

  const keyPoints = [
    {
      icon: Calculator,
      title: 'The Formula',
      description: 'Kelly % = (p × b - q) / b, where p is win probability, q is loss probability, and b is the odds received',
      color: 'from-green-400 to-emerald-400'
    },
    {
      icon: TrendingUp,
      title: 'What It Does',
      description: 'Maximizes long-term geometric growth rate of your bankroll when you have a true edge',
      color: 'from-blue-400 to-cyan-400'
    },
    {
      icon: AlertTriangle,
      title: 'The Risks',
      description: '33% chance of halving bankroll before doubling. Very high variance. Requires accurate probabilities',
      color: 'from-orange-400 to-red-400'
    },
    {
      icon: Info,
      title: 'Best Practice',
      description: 'Most pros use 25-50% of Kelly (fractional Kelly) to reduce variance while maintaining growth',
      color: 'from-purple-400 to-pink-400'
    }
  ];

  return (
    <section className="py-32 bg-gray-900 relative overflow-hidden">
      <div className="max-w-7xl mx-auto px-4">
        <motion.div 
          ref={ref}
          className="text-center mb-16"
          initial={{ opacity: 0, y: 20 }}
          animate={inView ? { opacity: 1, y: 0 } : {}}
          transition={{ duration: 0.8 }}
        >
          <motion.div 
            className="inline-flex items-center gap-2 px-4 py-2 bg-yellow-500/10 border border-yellow-500/30 rounded-full mb-6"
            initial={{ scale: 0 }}
            animate={inView ? { scale: 1 } : {}}
            transition={{ delay: 0.2, type: "spring" }}
          >
            <Info className="w-4 h-4 text-yellow-400" />
            <span className="text-yellow-400 text-sm font-mono">UNDERSTANDING KELLY</span>
          </motion.div>

          <h2 className="text-4xl sm:text-5xl font-bold text-white mb-6">
            <span className="block">What Kelly Criterion</span>
            <span className="block text-transparent bg-clip-text bg-gradient-to-r from-yellow-400 to-orange-400">
              Actually Promises
            </span>
          </h2>
          
          <p className="text-xl text-gray-400 max-w-3xl mx-auto">
            The Kelly Criterion is powerful but often misunderstood. Here's what you need to know.
          </p>
        </motion.div>

        <div className="grid md:grid-cols-2 lg:grid-cols-4 gap-6 mb-16">
          {keyPoints.map((point, index) => (
            <motion.div
              key={index}
              className="bg-black/50 backdrop-blur-sm border border-gray-800 rounded-2xl p-6"
              initial={{ opacity: 0, y: 20 }}
              animate={inView ? { opacity: 1, y: 0 } : {}}
              transition={{ delay: 0.2 + index * 0.1 }}
            >
              <div className={`w-12 h-12 rounded-xl bg-gradient-to-br ${point.color} p-0.5 mb-4`}>
                <div className="w-full h-full bg-gray-900 rounded-xl flex items-center justify-center">
                  <point.icon className="w-6 h-6 text-white" />
                </div>
              </div>
              <h3 className="text-lg font-bold text-white mb-2">{point.title}</h3>
              <p className="text-gray-400 text-sm">{point.description}</p>
            </motion.div>
          ))}
        </div>

        <motion.div 
          className="bg-black/50 backdrop-blur-sm border border-yellow-500/30 rounded-2xl p-8"
          initial={{ opacity: 0 }}
          animate={inView ? { opacity: 1 } : {}}
          transition={{ delay: 0.8 }}
        >
          <h3 className="text-2xl font-bold text-white mb-6 text-center">
            Critical Requirements for Kelly Success
          </h3>
          
          <div className="grid md:grid-cols-2 gap-8">
            <div>
              <h4 className="text-lg font-semibold text-yellow-400 mb-3">You Must Have:</h4>
              <ul className="space-y-2 text-gray-300">
                <li className="flex items-start gap-2">
                  <span className="text-green-400 mt-1">✓</span>
                  <span>A genuine positive expected value (true edge)</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="text-green-400 mt-1">✓</span>
                  <span>Accurate probability estimates (hardest part)</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="text-green-400 mt-1">✓</span>
                  <span>Stomach for high variance (big swings)</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="text-green-400 mt-1">✓</span>
                  <span>Long-term perspective (hundreds of bets)</span>
                </li>
              </ul>
            </div>
            
            <div>
              <h4 className="text-lg font-semibold text-red-400 mb-3">Common Mistakes:</h4>
              <ul className="space-y-2 text-gray-300">
                <li className="flex items-start gap-2">
                  <span className="text-red-400 mt-1">✗</span>
                  <span>Overestimating your edge (leads to overbetting)</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="text-red-400 mt-1">✗</span>
                  <span>Using full Kelly (too volatile for most)</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="text-red-400 mt-1">✗</span>
                  <span>Expecting smooth returns (it's very bumpy)</span>
                </li>
                <li className="flex items-start gap-2">
                  <span className="text-red-400 mt-1">✗</span>
                  <span>Betting without a true edge (guaranteed loss)</span>
                </li>
              </ul>
            </div>
          </div>

          <div className="mt-8 p-4 bg-yellow-500/10 rounded-lg">
            <p className="text-center text-yellow-400 font-semibold">
              Remember: Kelly Criterion doesn't create an edge—it only optimizes bet sizing when you already have one.
            </p>
          </div>
        </motion.div>
      </div>
    </section>
  );
};

export default KellyExplainer;