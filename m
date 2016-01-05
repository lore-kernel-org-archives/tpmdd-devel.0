From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Question on Linux TSS architecture design (kernel
 vs. user space access)
Date: Tue, 5 Jan 2016 10:39:11 -0700
Message-ID: <20160105173911.GC16269@obsidianresearch.com>
References: <9F48E1A823B03B4790B7E6E69430724DA586A57C@EXCH2010B.sit.fraunhofer.de>
	<20151222212348.GB9461@obsidianresearch.com>
	<n5ed19$pqo$1@ger.gmane.org> <20151224114241.GA5119@intel.com>
	<n5h1rj$nkb$1@ger.gmane.org>
	<20160102203957.GA19490@obsidianresearch.com>
	<20160103135346.GA4047@intel.com>
	<9F48E1A823B03B4790B7E6E69430724DA5877E95@EXCH2010B.sit.fraunhofer.de>
	<20160104181915.GA15908@intel.com>
	<9F48E1A823B03B4790B7E6E69430724DA58784A8@EXCH2010B.sit.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9F48E1A823B03B4790B7E6E69430724DA58784A8-wI35/lLZEdRyXeJKmmMAp2SU2VBt9E6NG9Ur7JDdleE@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: "Fuchs, Andreas" <andreas.fuchs-iXjGqz/onsDSyEMIgutvibNAH6kLmebB@public.gmane.org>
Cc: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, "tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

On Tue, Jan 05, 2016 at 09:43:04AM +0000, Fuchs, Andreas wrote:
> The current semantics of a ResoureManager does not include the concept of
> dup()'ing application contexts or concurrent access to session or
> key objects

Don't worry about this. The singleton context is the struct file in
the kernel, and it is never copied or dup'd.

How user space uses the struct file from multiple threads/processes
sanely is a different question the kernel doesn't have to answer.

> Side-Question: how does the current tpm-fd handle fork() and dup() ? Since it is
> single access only as well ?

It is not really single access.

>From a uapi perspective the question is how do you design the char dev
to be useful in a threaded scenario.

The current uapi is write,poll,read which cannot be run concurrently,
but does allow a multiplex'd sleep for long operations.

An alternative would be a synchronous ioctl which would be safe in a
multi-threaded environment but not no longer pollable.

In any event, it is up to the application to ensure different
threads/processes do not step on each other from a TPM spec
perspective. That is not something the kernel need to worry about.

As I've said to Ken, the starting place for any work, and the natural
first patch, should be a new uapi that allows unprivileged access to
the TPMs. An obvious trivial starting point is to enable the obviously
safe commands like get capability and get random. Progressively build
up more capabilities from that point.

Jason

------------------------------------------------------------------------------
