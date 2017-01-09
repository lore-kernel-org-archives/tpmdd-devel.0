From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH RFC 0/4] RFC: in-kernel resource manager
Date: Tue, 10 Jan 2017 01:16:35 +0200
Message-ID: <20170109231635.6wh25qoy7svcnys6@intel.com>
References: <kgoldman@us.ibm.com>
 <201701041612.v04GCfPK031525@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201701041612.v04GCfPK031525@wind.enjellic.com>
Sender: owner-linux-security-module@vger.kernel.org
To: greg@enjellic.com
Cc: Ken Goldman <kgoldman@us.ibm.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
List-Id: tpmdd-devel@lists.sourceforge.net

On Wed, Jan 04, 2017 at 10:12:41AM -0600, Dr. Greg Wettstein wrote:
> The kernel needs a resource manager.  Everyone needs to think VERY
> hard and VERY, VERY carefully about what gets put into the kernel.  In
> making a decision, put the ABSOLUTE smallest amount of code into the
> kernel which allows various 'TPM2 personalities' to be implemented in
> userspace and functionally verified and protected by the physical
> instance.  The emergence of commodity TEE's (SGX, et.al) should be in
> the back of everyone's mind as a factor in the roadmap.

Here's my cuts for the kernel:

- Kernel virtualizes handle areas. It's mechanical.
- Kernel does not virtualize bodies. It's not mechanical.
- At least the first version of the RM will not do other than session
  isolation for sessions.

This keeps the core for RM inside the kernel small and tight.

If we start to do some weird shit to the bodies that we think is 
good after long hours over engineering, the implementation will be
a failure. In the user space the way bodies are virtualizes is easier
to fine-tune because it doesn't break every possible app using the
in-kernel RM.

/Jarkko
