From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [tpmdd-devel] [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Fri, 6 Jan 2017 12:02:52 -0700
Message-ID: <20170106190252.GA19421@obsidianresearch.com>
References: <20170102132213.22880-1-jarkko.sakkinen@linux.intel.com>
 <9F48E1A823B03B4790B7E6E69430724DC7C149F6@exch2010c.sit.fraunhofer.de>
 <20170105172726.GA11680@obsidianresearch.com>
 <1483641223.2515.62.camel@linux.vnet.ibm.com>
 <20170105192025.GB12587@obsidianresearch.com>
 <1483646149.2515.83.camel@linux.vnet.ibm.com>
 <20170105222118.GC31047@obsidianresearch.com>
 <1483657126.2515.107.camel@linux.vnet.ibm.com>
 <20170105235046.GA4670@obsidianresearch.com>
 <1483663002.2515.134.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1483663002.2515.134.camel@linux.vnet.ibm.com>
Sender: owner-linux-security-module@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>
Cc: "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "tpmdd-devel@lists.sourceforge.net" <tpmdd-devel@lists.sourceforge.net>, open list <linux-kernel@vger.kernel.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Thu, Jan 05, 2017 at 04:36:42PM -0800, James Bottomley wrote:

> I'm seriously pissed of with trousers and will port the trousers based
> TPM1.2 RSA key patches I've done to whatever direct connect API you
> come up with (just send me a link to the git tree or package or
> whatever), so this should generate some use experience for 1.2, like
> whether we actually need a RM without trousers and also what the safety
> issues might be.  My main laptop is now TPM2, but I have a backup one
> that's TPM1.2 and also has all the TPM key stuff as well.

I would like to add basic 1.2 support to Jarkko's RM. I'm not sure if
my 5mth old will ever let me..

If we do that we write a simple broker as I described that works on
both 1.2 and 2.0 and trousers can go away.

Jason
